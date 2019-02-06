FROM alpine:3.7

COPY docker /tmp/

RUN /bin/sh /tmp/build.sh

ENV SKS_HOSTNAME="localhost" \
    SKS_RECON_ADDR="0.0.0.0" \
    SKS_RECON_PORT="11370" \
    SKS_HKP_ADRESS="0.0.0.0" \
    SKS_HKP_PORT="11371" \
    SKS_SERVER_CONTACT="" \
    SKS_NODENAME="keys" \
    SKS_COMMAND_TIMEOUT="600" \
    SKS_WSERVER_TIMEOUT="30" \
    SKS_MAX_RECOVER="150"

WORKDIR /var/lib/sks/

VOLUME ["/var/lib/sks/"]

EXPOSE 11371 11370

ENTRYPOINT ["/bin/run.sh"]
