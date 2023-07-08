FROM python:3.10-bullseye@sha256:c9477e5f48f256a74c55d5a28eeb142f2b2a5b93f0933ade974cc1d0665682d2

RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    vim \
    wget \
    universal-ctags \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 appuser
RUN useradd -m -s /bin/bash -u 1000 -g 1000 \
    -G sudo,adm,sudo,plugdev,cdrom,www-data \
    appuser

# prepare folder for the venv
RUN mkdir -p /opt/venv
RUN chown -R appuser:appuser /opt/venv

# prepare folder for the code
RUN mkdir -p /src
RUN chown -R appuser:appuser /src

USER appuser

# make a venv
RUN python3 -m venv /opt/venv

# use the venv
ENV PATH="/opt/venv/bin:$PATH"

# Download pip from pypa
RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
# Install pip without interaction
RUN python3 /tmp/get-pip.py

# install requirements
# we have to use ./app because of our docker build context
# being set to the parent directory
COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

#comment this for development:
#RUN pip install aider-chat


# install scripts into the container
USER root
COPY scripts/checkinstall.sh /usr/local/bin/checkinstall.sh
RUN chmod +x /usr/local/bin/checkinstall.sh
COPY scripts/development.sh /usr/local/bin/development.sh
RUN chmod +x /usr/local/bin/development.sh
COPY scripts/resetaider.sh /usr/local/bin/resetaider.sh
RUN chmod +x /usr/local/bin/resetaider.sh

# switch back to appuser
# (the venv is still/already) in the path:
USER appuser

# Move this up later:
RUN echo "alias aider='aider --code-theme=monokai'" >> /home/appuser/.bashrc

WORKDIR /workdir
