FROM ubuntu:18.04

ARG TERRAFORM_VERSION=1.3.5
ARG acr=''

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN echo 'Updating the list of available packages and versions, upgrading installed packages, and installing essential packages'
RUN apt update && apt-get upgrade -y -qq && apt install -y --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    file \
    gcc \
    git \
    jq \
    iputils-ping \
    libcurl4 \
    libicu60 \
    libodbc1 \
    libssl1.0 \
    libunwind8 \
    netcat \
    software-properties-common \
    unzip \
    wget \
    zip \
  && rm -rf /var/lib/apt/lists/*

RUN echo 'Setting environment variables'
RUN echo 'export PATH="$PATH:/home/$(whoami)/.local/bin"' >> ~/.bashrc

RUN echo "Downloading AzCopy"
RUN wget -O azcopy_v10.tar.gz https://aka.ms/downloadazcopy-v10-linux && tar -xf azcopy_v10.tar.gz --strip-components=1
RUN cp ./azcopy /usr/bin/

RUN echo 'Installing Az cli'
RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && rm -rf /var/lib/apt/lists/*

RUN echo 'Installing azure cli extensions'
RUN az extension add --name resource-graph
RUN az extension add --name azure-devops
RUN az extension add --name logic

RUN echo 'Installing Terraform'
RUN apt update && apt install -y gnupg
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN apt update
RUN apt-get install terraform=${TERRAFORM_VERSION}