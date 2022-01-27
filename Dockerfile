FROM jupyter/scipy-notebook:ubuntu-20.04

# install the notebook package etc.
RUN pip install --no-cache --upgrade pip \
    && pip install --no-cache notebook \
    && pip install --no-cache jupyter_contrib_nbextensions \
    && pip install --no-cache git+https://github.com/NII-cloud-operation/Jupyter-LC_run_through \
    && pip install --no-cache git+https://github.com/NII-cloud-operation/Jupyter-multi_outputs \
    && pip install --no-cache datalad==0.15.4

RUN jupyter contrib nbextension install --user \
    && jupyter nbextensions_configurator enable --user \
    && jupyter run-through quick-setup --user \
    && jupyter nbextension install --py lc_multi_outputs --user \
    && jupyter nbextension enable --py lc_multi_outputs --user

ARG NB_USER=jovyan
ARG NB_UID=1000

WORKDIR ${HOME}
COPY . ${HOME}

USER root
RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}
