#### Build NGINX with VTS module
FROM alpine:3.19 AS build
LABEL maintainer="yohrannes@gmail.com"

# Instala dependências para compilar o NGINX
RUN apk add --no-cache \
    git \
    gcc \
    make \
    libc-dev \
    pcre \
    pcre-dev \
    zlib \
    zlib-dev \
    openssl \
    openssl-dev \
    wget \
    curl

# Clona o módulo VTS e compila o NGINX
RUN git clone https://github.com/vozlt/nginx-module-vts.git  /tmp/nginx-module-vts \
    && wget http://nginx.org/download/nginx-1.25.2.tar.gz -O /tmp/nginx.tar.gz \
    && cd /tmp && tar -xzf nginx.tar.gz \
    && cd /tmp/nginx-1.25.2 \
    && ./configure --prefix=/etc/nginx --add-module=/tmp/nginx-module-vts \
    && make && make install

#### Final Stage
FROM alpine:3.19
LABEL maintainer="yohrannes@gmail.com"

# Instala dependências de runtime
RUN apk add --no-cache pcre zlib openssl

# Copia os arquivos do NGINX compilado
COPY --from=build /etc/nginx /etc/nginx

# Copia o arquivo de configuração personalizado
COPY nginx.conf /etc/nginx/conf/nginx.conf

# Adiciona o binário do NGINX ao PATH
ENV PATH="/etc/nginx/sbin:$PATH"

# Define o usuário como root
USER root

RUN mkdir -p /var/log/nginx && chmod -R 755 /var/log/nginx

# Healthcheck para validar a configuração do NGINX
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 CMD ["nginx", "-t"]

# Comando para iniciar o NGINX
CMD ["nginx", "-g", "daemon off;", "-c", "/etc/nginx/conf/nginx.conf"]