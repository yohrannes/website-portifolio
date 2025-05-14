FROM hashicorp/terraform:latest

RUN apk add --no-cache oci-cli jq curl nano --quiet && curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && mv kubectl /usr/local/bin/kubectl

WORKDIR /app

COPY tfinu/.shrc /root/.shrc

ENTRYPOINT []
CMD ["sh", "-c", "source /root/.shrc && terraform init -reconfigure -input=false && exec env ENV=/root/.shrc sh"]