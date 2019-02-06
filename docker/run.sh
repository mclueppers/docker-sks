#! /bin/sh
#
# run.sh
# Copyright (C) 2019 Martin Dobrev <martin@dobrev.eu>
# Copyright (C) 2017 Óscar García Amor <ogarcia@connectical.com>
#
# Distributed under terms of the MIT license.
#

# Make config file
if ! test -f /var/lib/sks/sksconf; then
cat > /var/lib/sks/sksconf << EOF
hostname: ${SKS_HOSTNAME}
recon_address: ${SKS_RECON_ADDR}
recon_port: ${SKS_RECON_PORT}
hkp_address: ${SKS_HKP_ADRESS}
hkp_port: ${SKS_HKP_PORT}
initial_stat:
pagesize: 16
ptree_pagesize: 16
nodename: ${SKS_NODENAME}
disable_mailsync:
debuglevel: 3
membership_reload_interval: 1
stat_hour: 17
server_contact: ${SKS_SERVER_CONTACT}
command_timeout: 600
wserver_timeout: 30
max_recover: 150
EOF
else
sed -i "\
  s/hostname:.*/hostname: ${SKS_HOSTNAME}/g; \
  s/recon_address:.*/recon_address: ${SKS_RECON_ADDR}/g; \
  s/recon_port:.*/recon_port: ${SKS_RECON_PORT}/g; \
  s/hkp_address:.*/hkp_address: ${SKS_HKP_ADRESS}/g; \
  s/hkp_port:.*/hkp_port: ${SKS_HKP_PORT}/g; \
  s/nodename:.*/nodename: ${SKS_NODENAME}/g; \
  s/server_contact:.*/server_contact: ${SKS_SERVER_CONTACT}/g; \
  s/command_timeout:.*/command_timeout: ${SKS_COMMAND_TIMEOUT}/g; \
  s/wserver_timeout:.*/wserver_timeout: ${SKS_WSERVER_TIMEOUT}/g; \
  s/max_recover:.*/max_recover: ${SKS_MAX_RECOVER}/g; \
  " sksconf
fi

# Make empty membership file
if ! test -f /var/lib/sks/membership; then
  touch /var/lib/sks/membership
fi

# Make empty web
if ! test -d /var/lib/sks/web; then
  mkdir -p /var/lib/sks/web
  touch /var/lib/sks/web/index.html
fi

# Start daemons
if [ $# -gt 0 ];then
  exec "$@"
else
  exec /init
fi
