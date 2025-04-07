ARG BUILD_FROM=ghcr.io/hassio-addons/base:17.2.4
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        gcc=14.2.0-r4 \
        linux-pam-dev=1.6.1-r1 \
        make=4.4.1-r2 \
        musl-dev=1.2.5-r9 \
    \
    && cd /tmp \
    && curl -sSL https://github.com/tiwe-de/libpam-pwdfile/archive/v1.0.tar.gz \
        | tar xz --strip 1 \
    && make \
    && PAM_LIB_DIR=/usr/lib/security make install \
    && cd - \
    \
    && apk add --no-cache \
        openssl=3.3.3-r0 \
        vsftpd=3.0.5-r2 \
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
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION
# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
