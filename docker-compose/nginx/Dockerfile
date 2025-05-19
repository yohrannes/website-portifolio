#### Build NGINX with VTS module
FROM alpine:3.19 AS build
LABEL maintainer="yohrannes@gmail.com"
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
RUN git clone https://github.com/vozlt/nginx-module-vts.git  /tmp/nginx-module-vts \
    && wget http://nginx.org/download/nginx-1.25.2.tar.gz -O /tmp/nginx.tar.gz \
    && cd /tmp && tar -xzf nginx.tar.gz \
    && cd /tmp/nginx-1.25.2 \
    && ./configure --prefix=/etc/nginx --add-module=/tmp/nginx-module-vts \
    && make && make install

#FROM alpine:3.19
LABEL maintainer="yohrannes@gmail.com"
RUN apk add --no-cache pcre zlib openssl


#COPY --from=build /etc/nginx /etc/nginx

###COMMENT TO RUN IN PRODUCTION
COPY ./conf.d/vts.conf /etc/nginx/conf.d/vts.conf

COPY nginx.conf /etc/nginx/conf/nginx.conf
ENV PATH="/etc/nginx/sbin:$PATH"
USER root
RUN mkdir -p /var/log/nginx && chmod -R 755 /var/log/nginx

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 CMD ["nginx", "-t"]
CMD ["nginx", "-g", "daemon off;", "-c", "/etc/nginx/conf/nginx.conf"]