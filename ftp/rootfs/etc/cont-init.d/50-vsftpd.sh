#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: FTP
# Configures vsftpd
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly CONFIG=/etc/vsftpd/vsftpd.conf

# Configure ports
{
    echo "listen_port=$(hass.config.get 'port')"
    echo "ftp_data_port=$(hass.config.get 'data_port')"
} >> "${CONFIG}"

# Passive mode
if hass.config.true 'pasv'; then
    {
        echo 'pasv_enable=YES'
        echo "pasv_min_port=$(hass.config.get 'pasv_min_port')"
        echo "pasv_max_port=$(hass.config.get 'pasv_max_port')"
    } >> "${CONFIG}"
    
    # Has the user configured a passive address?
    if hass.config.has_value 'pasv_address'; then
        echo "pasv_address=$(hass.config.get 'pasv_address')" >> "${CONFIG}"
    fi
else
    echo 'pasv_enable=NO' >> "${CONFIG}"
fi

# SSL
if hass.config.true 'ssl'; then
    {
        echo 'ssl_enable=YES'
        echo 'ssl_sslv2=NO'
        echo 'ssl_sslv3=NO'
        echo 'ssl_tlsv1=YES'
        echo "rsa_cert_file=/ssl/$(hass.config.get 'certfile')"
        echo "rsa_private_key_file=/ssl/$(hass.config.get 'keyfile')"
    } >> "${CONFIG}"

    if hass.config.true 'implicit_ssl'; then
        echo 'implicit_ssl=YES' >> "${CONFIG}"
    else
        echo 'implicit_ssl=NO' >> "${CONFIG}"
    fi
else
    echo 'ssl_enable=NO' >> "${CONFIG}"
fi

# Debug mode
if hass.debug; then
    echo 'log_ftp_protocol=YES' >> "${CONFIG}"
    if hass.config.true 'ssl'; then
        echo 'debug_ssl=YES' >> "${CONFIG}"
    fi
fi

# Other settings
{
    echo "ftpd_banner=$(hass.config.get 'banner')"
    echo "max_clients=$(hass.config.get 'max_clients')"
} >> "${CONFIG}"
