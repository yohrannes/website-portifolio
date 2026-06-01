FROM hashicorp/packer:full AS packer
FROM hashicorp/terraform:latest

COPY --from=packer /bin/packer /bin/packer

ENV PACKER_CONFIG_DIR=/home/clouduser/.config/packer
ENV PACKER_CACHE_DIR=/home/clouduser/.cache/packer
ENV PACKER_LOG_PATH=/tmp/packer.log
ENV PACKER_TMP_DIR=/tmp/packer

ENV OCI_CONFIG_FILE_PATH=/home/clouduser/.oci/packer/oci_config
ENV OCI_CONFIG_PROFILE=DEFAULT
ENV OCI_CLI_SUPPRESS_FILE_PERMISSIONS_WARNING=True

RUN mkdir -p ${PACKER_CONFIG_DIR} \
    && mkdir -p ${PACKER_CACHE_DIR} \
    && mkdir -p ${PACKER_CONFIG_DIR}/plugins \
    && mkdir -p ${PACKER_TMP_DIR}

WORKDIR /home/clouduser

RUN apk add --no-cache oci-cli jq shadow curl nano --quiet && curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && mv kubectl /usr/local/bin/kubectl

RUN adduser -D clouduser

#RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz && tar -xf google-cloud-cli-linux-x86_64.tar.gz && rm google-cloud-cli-linux-x86_64.tar.gz
#RUN yes | ./google-cloud-sdk/install.sh

ENV CLOUDSDK_INSTALL_DIR=/usr/lib

ENV CLOUDSDK_CONFIG=/home/clouduser/.config/gcloud

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz && \
    tar -xf google-cloud-cli-linux-x86_64.tar.gz -C ${CLOUDSDK_INSTALL_DIR} && \
    rm google-cloud-cli-linux-x86_64.tar.gz && \
    ${CLOUDSDK_INSTALL_DIR}/google-cloud-sdk/install.sh --quiet --usage-reporting=false --path-update=true

ENV PATH="/usr/lib/google-cloud-sdk/bin:${PATH}"


WORKDIR /app/packer/prod/ansible
RUN apk add --no-cache python3 py3-pip --quiet
RUN python3 -m venv venv

WORKDIR /app

#USER clouduser
#ARG HOME

COPY webport-cli/.shrc /home/clouduser/.shrc
COPY webport-cli/init-all.sh /home/clouduser/init-all.sh
RUN chmod +x /home/clouduser/init-all.sh

ENTRYPOINT []
CMD ["sh", "-c", "/home/clouduser/init-all.sh"]
