#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: FTP
# Configures vsftpd
# ==============================================================================
readonly CONFIG=/etc/vsftpd/vsftpd.conf

bashio::config.require.ssl

# Configure ports
{
    echo "listen_port=$(bashio::config 'port')"
    echo "ftp_data_port=$(bashio::config 'data_port')"
} >> "${CONFIG}"

# Passive mode
if bashio::config.true 'pasv'; then
    {
        echo 'pasv_enable=YES'
        echo "pasv_min_port=$(bashio::config 'pasv_min_port')"
        echo "pasv_max_port=$(bashio::config 'pasv_max_port')"
    } >> "${CONFIG}"

    # Has the user configured a passive address?
    if bashio::config.has_value 'pasv_address'; then
        echo "pasv_address=$(bashio::config 'pasv_address')" >> "${CONFIG}"
    fi

    if bashio::config.true 'pasv_addr_resolve'; then
        echo 'pasv_addr_resolve=YES' >> "${CONFIG}"
    fi
else
    echo 'pasv_enable=NO' >> "${CONFIG}"
fi

# SSL
if bashio::config.true 'ssl'; then
    {
        echo 'ssl_enable=YES'
        echo 'ssl_sslv2=NO'
        echo 'ssl_sslv3=NO'
        echo 'ssl_tlsv1=YES'
        echo "rsa_cert_file=/ssl/$(bashio::config 'certfile')"
        echo "rsa_private_key_file=/ssl/$(bashio::config 'keyfile')"
    } >> "${CONFIG}"

    if bashio::config.true 'implicit_ssl'; then
        echo 'implicit_ssl=YES' >> "${CONFIG}"
    else
        echo 'implicit_ssl=NO' >> "${CONFIG}"
    fi
else
    echo 'ssl_enable=NO' >> "${CONFIG}"
fi

# Debug mode
if bashio::debug; then
    echo 'log_ftp_protocol=YES' >> "${CONFIG}"
    if bashio::config.true 'ssl'; then
        echo 'debug_ssl=YES' >> "${CONFIG}"
    fi
fi

# Other settings
{
    echo "ftpd_banner=$(bashio::config 'banner')"
    echo "max_clients=$(bashio::config 'max_clients')"
} >> "${CONFIG}"
