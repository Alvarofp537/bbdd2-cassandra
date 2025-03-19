FROM quay.io/jupyter/pytorch-notebook

USER root

WORKDIR /home/jovyan

ARG user_id=1000
RUN usermod -u $user_id jovyan

USER jovyan

RUN pip install -qU \
    redis \
    matplotlib \
    scipy \
    pandas \
    transformers \
    accelerate \
    einops \
    pillow \
    xformers \
    bitsandbytes


