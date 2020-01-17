FROM sunbird/base_ubuntu_ruby_azure

# Switch to root
USER root

# Work Directory
WORKDIR project/installations/

COPY build.sh /project/installations/
ENTRYPOINT ./build.sh

