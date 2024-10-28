FROM ubuntu:24.04

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && apt-get --yes install --no-install-recommends ca-certificates && \
    apt-get update && apt-get --yes install \
    sudo build-essential nasm \
    wget curl pkg-config cmake zlib1g unzip zip git supervisor openssl \
    dovecot-core dovecot-imapd dovecot-lmtpd dovecot-managesieved dovecot-mysql dovecot-pop3d dovecot-sieve \
    postfix postfix-mysql \
    opendkim && \
    rm -rf /var/lib/apt/lists/*

# copy scripts
COPY ./scripts/install.sh /install.sh

# run install script
RUN chmod +x /install.sh && /install.sh

