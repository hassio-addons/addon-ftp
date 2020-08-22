ARG BUILD_FROM=hassioaddons/base:8.0.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        gcc=9.3.0-r2 \
        linux-pam-dev=1.3.1-r4 \
        make=4.2.1-r2 \
        musl-dev=1.1.24-r2 \
    \
    && cd /tmp \
    && curl -sSL https://github.com/tiwe-de/libpam-pwdfile/archive/v1.0.tar.gz \
        | tar xz --strip 1 \
    && make \
    && make install \
    && cd - \
    \
    && apk add --no-cache \
        openssl=1.1.1g-r0 \
        vsftpd=3.0.3-r6 \
    \
    && apk del --no-cache --purge .build-dependencies \
    \
    && mkdir -p \
        /ftproot/empty \
        /ftproot/users \
        /etc/vsftpd/users \
    \
    && rm -f -r \
        /tmp/*

 # Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="FTP" \
    io.hass.description="A secure and fast FTP server for Home Assistant" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="FTP" \
    org.opencontainers.image.description="A secure and fast FTP server for Home Assistant" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/hassio-addons/addon-ftp" \
    org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-ftp/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
