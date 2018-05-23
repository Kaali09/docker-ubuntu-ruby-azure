FROM ubuntu:16.04

# Switch to root
USER root

# Work Directory
WORKDIR project/installations/

# Update everything
RUN apt-get update

# Install Dependencies
RUN apt-get install -y build-essential=12.1ubuntu2 \
					   zlib1g-dev=1:1.2.8.dfsg-2ubuntu4.1 \
					   locales \
					   curl \
					   git \
					   openjdk-8-jre \
					   ssh \
					   jq
					   
# Install Ruby & Gems
RUN apt-get install -y ruby-full=1:2.3.0+1
RUN mkdir -p /usr/share/ruby
COPY Gemfile /project/installations/
COPY Gemfile.lock /project/installations/
RUN gem install bundler --no-ri --no-rdoc
RUN bundle install --system
RUN gem clean

# Install yq & Python
RUN apt-get install -y python python-pip groff
RUN pip install --upgrade pip
RUN pip install yq

# Environment Setup
ENV TZ=Asia/Calcutta
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Install Azure

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV AZURE_CLI_VERSION "0.10.13"
ENV NODEJS_APT_ROOT "node_6.x"
ENV NODEJS_VERSION "6.10.0"

RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends\
      apt-transport-https \
      build-essential \
      curl \
      ca-certificates \
      git \
      lsb-release \
      python-all \
      rlwrap \
      vim \
      nano \
      jq && \
    rm -rf /var/lib/apt/lists/* && \
    curl https://deb.nodesource.com/${NODEJS_APT_ROOT}/pool/main/n/nodejs/nodejs_${NODEJS_VERSION}-1nodesource1~jessie1_amd64.deb > node.deb && \
      dpkg -i node.deb && \
      rm node.deb && \
      npm install --global azure-cli@${AZURE_CLI_VERSION} && \
      azure --completion >> ~/azure.completion.sh && \
      echo 'source ~/azure.completion.sh' >> ~/.bashrc && \
      azure

RUN azure config mode arm
