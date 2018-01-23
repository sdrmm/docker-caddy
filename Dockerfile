FROM lsiobase/alpine:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="p3lim"

# package versions and plugins etc
ARG CADDY_ARCH="amd64"
ARG CADDY_PLUGS="http.ipfilter,http.login,http.jwt"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl && \
 echo "**** install caddy and plugins ****" && \
 curl -o \
 /tmp/caddy.tar.gz -L \
	"https://caddyserver.com/download/linux/${CADDY_ARCH}?license=personal&plugins=${CADDY_PLUGS}" && \
 tar -xf \
 /tmp/caddy.tar.gz -C \
	/usr/local/bin/

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config

# run caddy
CMD ["/usr/local/bin/caddy", "-conf", "/config/Caddyfile", "-root", "/config/www"]
