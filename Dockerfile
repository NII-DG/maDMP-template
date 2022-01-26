FROM jupyter/scipy-notebook:ubuntu-20.04

# install debian package (datalad-cli etc.)
# RUN apt update -y \
#     && apt upgrade -y \
#     && apt autoremove -y \
#     && apt install -y datalad \
#     && apt clean \
#     && rm -rf /var/lib/apt/lists/*

# install the notebook package etc.
RUN pip install --no-cache --upgrade pip \
    && pip install --no-cache notebook jupyterlab \
    && pip install --no-cache datalad==0.15.4

ARG NB_USER=jovyan
ARG NB_UID=1000

WORKDIR ${HOME}
COPY . ${HOME}

USER root
RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}
