#!/bin/bash

set -e

#judgement
if [[ -a /etc/supervisor/conf.d/supervisord.conf ]]; then
  exit 0
fi

#supervisor
cat > /etc/supervisor/conf.d/supervisord.conf <<EOF
[supervisord]
nodaemon=true
[program:postfix]
command=/opt/postfix.sh
[program:dovecot]
command=/opt/dovecot.sh
[program:opendkim]
command=opendkim -f
EOF

# [program:rsyslog]
# command=/usr/sbin/rsyslogd -n


# config for postfix
# ref: https://www.postfix.org/COMPATIBILITY_README.html
postconf compatibility_level=3.6

cat >> /opt/postfix.sh <<EOF
#!/bin/bash

set -e

# https://serverfault.com/questions/885828/is-there-any-way-to-run-postfix-in-foreground
mkdir -p /var/spool/postfix/hold
chown -R postfix /var/spool/postfix/hold
chmod -R 755 /var/spool/postfix/hold

postfix -c /etc/postfix  set-permissions
mkdir -p /usr/share/doc/postfix/html
chown -R postfix /usr/share/doc/postfix/html
chmod -R 755 /usr/share/doc/postfix/html

postfix start-fg
EOF
chmod +x /opt/postfix.sh

cat >> /opt/dovecot.sh <<EOF
#!/bin/bash

set -e

mkdir -p /var/mail/vhosts/
chown -R vmail /var/mail/vhosts/

/usr/sbin/dovecot -F
EOF
chmod +x /opt/dovecot.sh

# postfix -vvvvv start-fg

# chown -R postfix /var/spool/postfix
# chmod -R 755 /var/spool/postfix


# config for dovecot
useradd vmail

# ./conf.d/auth-sql.conf.ext
# args = uid=vmail gid=vmail home=/var/mail/vhosts/%d/%n