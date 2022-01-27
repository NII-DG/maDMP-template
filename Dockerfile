FROM jupyter/scipy-notebook:ubuntu-20.04

# install the notebook package etc.
RUN pip install --no-cache --upgrade pip \
    && pip install --no-cache notebook \
    && pip install --no-cache jupyter_contrib_nbextensions \
    && pip install --no-cache git+https://github.com/NII-cloud-operation/Jupyter-LC_run_through \
    && pip install --no-cache git+https://github.com/NII-cloud-operation/Jupyter-multi_outputs \
    && pip install --no-cache datalad==0.15.4 \
    && pip install --no-cache lxml==4.7.1 \
    && pip install --no-cache blockdiag==3.0.0 \
    && pip install --no-cache nbformat==5.1.3

RUN jupyter contrib nbextension install --user \
    && jupyter nbextensions_configurator enable --user \
    && jupyter run-through quick-setup --user \
    && jupyter nbextension install --py lc_multi_outputs --user \
    && jupyter nbextension enable --py lc_multi_outputs --user

# install Japanese-font (for blockdiag)
ARG font_deb=fonts-ipafont-gothic_00303-18ubuntu1_all.deb
RUN mkdir ${HOME}/.fonts \
    && wget -P ${HOME}/.fonts http://archive.ubuntu.com/ubuntu/pool/universe/f/fonts-ipafont/${font_deb} \
    && dpkg-deb -x ${HOME}/.fonts/${font_deb} ~/.fonts \
    && cp ~/.fonts/usr/share/fonts/opentype/ipafont-gothic/ipag.ttf ~/.fonts/ipag.ttf \
    && rm ${HOME}/.fonts/${font_deb} \
    && rm -rf ${HOME}/.fonts/etc ${HOME}/.fonts/usr

ARG NB_USER=jovyan
ARG NB_UID=1000

RUN rm -rf ${HOME}/work

WORKDIR ${HOME}
COPY . ${HOME}

USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
