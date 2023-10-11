# import OS & cuda
FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

# environment setting
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
# update packages
RUN apt-get upgrade && apt-get update -y

# app
RUN apt-get install git python3.9 python3-pip vim curl -y

# libraries to use GUI
RUN apt-get install x11-apps -y

# add user and group
ARG USERNAME=user
ARG GROUPNAME=user
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $GROUPNAME
RUN useradd -m -g $UID -g $GID $USERNAME
# make workspace
USER root
ARG WS=/home/$USERNAME/gp_optim
WORKDIR $WS

# copy config files in home directory
COPY .netrc /home/$USERNAME
COPY requirements.txt $WS

# install python libraries
RUN pip install --upgrade pip
RUN pip3 install --upgrade setuptools

# install jupyter lab and minimum required extensions (see below)
# https://qiita.com/nokonoko_1203/items/edd010616a74468ea531
RUN pip3 install --no-cache-dir \
    black \
    jupyterlab \
    #nodejs \
    jupyterlab-lsp \
    'python-lsp-server[all]' \
    lckr-jupyterlab-variableinspector \
    jupyterlab_code_formatter \
    jupyterlab-git \
    jupyterlab_widgets \
    ipywidgets \
    import-ipynb
    #notebook
    
# install basic python packages
RUN pip3 install --no-cache-dir -r requirements.txt

# change user
USER $USERNAME