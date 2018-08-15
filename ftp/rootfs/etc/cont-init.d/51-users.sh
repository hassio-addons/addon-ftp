#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: FTP
# Configures vsftpd
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

declare username
declare password

for user in $(hass.config.get 'users|keys[]'); do
    username=$(hass.config.get "users[${user}].username")

    mkdir -p "/ftproot/users/${username}"
    touch "/etc/vsftpd/users/${username}"

    for dir in "addons" "backup" "config" "share" "ssl"; do
        if hass.config.true "users[${user}].${dir}"; then
            mkdir "/ftproot/users/${username}/${dir}"
            mount --bind "/${dir}" "/ftproot/users/${username}/${dir}"
        fi
    done

    if hass.config.true "users[${user}].allow_chmod"; then
        echo 'chmod_enable=YES' >> "/etc/vsftpd/users/${username}"
    fi

    if hass.config.true "users[${user}].allow_download"; then
        echo 'download_enable=YES' >> "/etc/vsftpd/users/${username}"
    fi

    if hass.config.true "users[${user}].allow_upload"; then
        echo 'write_enable=YES' >> "/etc/vsftpd/users/${username}"
    fi

    if hass.config.true "users[${user}].allow_dirlist"; then
        echo 'dirlist_enable=YES' >> "/etc/vsftpd/users/${username}"
    fi

    # Require a secure password
    if hass.config.has_value "users[${user}].password" \
        && ! hass.config.is_safe_password "users[${user}].password"; then
        hass.die \
          "Please choose a different pass for ${username}, this one is unsafe!"
    fi

    password=$(hass.config.get "users[${user}].password" | openssl passwd -1 -stdin)
    echo "${username}:${password}" >> /etc/vsftpd/passwd
done
