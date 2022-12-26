FROM ubuntu:18.04

ARG TERRAFORM_VERSION=1.3.5
ARG PIP=pip3
ARG PYTHON=python3

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN echo 'Updating the list of available packages and versions, upgrading installed packages, and installing essential packages'
RUN apt-get update && apt upgrade -y -qq && apt-get install -y --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    figlet \
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
    odbcinst1debian2 \
    postgresql-client \
    python3-pip \
    python3-setuptools \
    python3-dev \
    software-properties-common \
    unixodbc \
    unixodbc-dev \
    unzip \
    wget \
    zip \
  && rm -rf /var/lib/apt/lists/*

RUN echo "Using ${PIP} to install python packages"

RUN echo 'Setting environment variables'
RUN echo 'export PYTHONWARNINGS="ignore:Unverified HTTPS request"' >> ~/.bashrc
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc 
RUN echo 'export PATH="$PATH:/home/$(whoami)/.local/bin"' >> ~/.bashrc

RUN echo "Downloading AzCopy"
RUN wget -O azcopy_v10.tar.gz https://aka.ms/downloadazcopy-v10-linux && tar -xf azcopy_v10.tar.gz --strip-components=1
RUN cp ./azcopy /usr/bin/

RUN echo 'Installing adal'
RUN apt-get update && apt upgrade -y -qq && apt-get install -y python3-adal

RUN echo 'Installing MS Rest Azure'
RUN apt-get install -y python3-msrestazure

RUN echo 'Installing Service Fabric Cli'
RUN ${PIP} install sfctl
RUN ${PIP} install future

RUN echo 'Installing pyodbc'
RUN ${PIP} install pyodbc

RUN echo 'Installing databricks cli'
RUN ${PIP} install databricks-cli

RUN echo 'Installing Az cli'
RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && rm -rf /var/lib/apt/lists/*

RUN echo 'Installing azure cli extensions'
RUN az extension add --name resource-graph
RUN az extension add --name azure-devops
RUN az extension add --name logic

RUN echo 'Installing Microsoft SQL tools'
RUN curl --silent https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl --silent https://packages.microsoft.com/config/ubuntu/18.04/prod.list | tee /etc/apt/sources.list.d/msprod.list
RUN apt-get update && ACCEPT_EULA=Y apt-get install mssql-tools -y
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile

RUN echo 'Installing PowerShell'
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update && apt-get install -y powershell

RUN echo 'Adding PSGallery as trusted repo'
RUN pwsh -NoLogo -NonInteractive -Command Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
RUN pwsh -Command Install-Module Az -Force
RUN pwsh -Command Install-Module dbatools -Force
RUN pwsh -NoLogo -NonInteractive -Command Enable-AzureRmAlias
RUN pwsh -Command Install-Module Posh-ACME -RequiredVersion 4.15.1 -Force
RUN echo 'export POWERSHELL_TELEMETRY_OPTOUT=true' >> ~/.bashrc

RUN echo 'Installing Terraform'
RUN apt-get update && apt-get install -y gnupg
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

RUN apt update
RUN apt-get install terraform=${TERRAFORM_VERSION}
