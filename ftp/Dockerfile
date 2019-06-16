ARG BUILD_FROM=hassioaddons/base:3.1.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        gcc=8.3.0-r0 \
        linux-pam-dev=1.3.0-r0 \
        make=4.2.1-r2 \
        musl-dev=1.1.20-r4 \
    \
    && cd /tmp \
    && curl -sSL https://github.com/tiwe-de/libpam-pwdfile/archive/v1.0.tar.gz \
        | tar xz --strip 1 \
    && make \
    && make install \
    && cd - \
    \
    && apk add --no-cache \
        openssl=1.1.1b-r1 \
        vsftpd=3.0.3-r6 \
    \
    && apk del --purge .build-dependencies \
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
    io.hass.description="A secure and fast FTP server for Hass.io" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="A secure and fast FTP server for Hass.io" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="FTP" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/t/community-hass-io-add-on-ftp/36799?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-ftp/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-ftp" \
    org.label-schema.vendor="Community Hass.io Add-ons"
