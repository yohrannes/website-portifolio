FROM hashicorp/terraform:latest

RUN apk add --no-cache oci-cli

WORKDIR /app

COPY tfinu/.shrc /root/.shrc

ENTRYPOINT []
CMD ["sh", "-c", "source /root/.shrc && terraform init -reconfigure && exec env ENV=/root/.shrc sh"]