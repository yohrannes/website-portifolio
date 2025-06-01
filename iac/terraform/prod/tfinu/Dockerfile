FROM hashicorp/terraform:latest

WORKDIR /root

RUN apk add --no-cache oci-cli jq curl nano --quiet && curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && mv kubectl /usr/local/bin/kubectl

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz && tar -xf google-cloud-cli-linux-x86_64.tar.gz && rm google-cloud-cli-linux-x86_64.tar.gz

RUN yes | ./google-cloud-sdk/install.sh

WORKDIR /app

COPY tfinu/.shrc /root/.shrc

ENTRYPOINT []
CMD ["sh", "-c", "source /root/.shrc && terraform init -reconfigure -input=false && exec env ENV=/root/.shrc sh"]