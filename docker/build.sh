#! /bin/sh
#
# build.bash
# Copyright (C) 2017 Óscar García Amor <ogarcia@connectical.com>
# Modified by (C) 2019 Martin Dobrev
#
# Distributed under terms of the MIT license.
#

# install run deps
apk -U --no-progress add db db-utils

# install build deps
apk --no-progress add curl camlp4 db-dev gcc libc-dev make zlib-dev ocaml

# Install s6-overlay
curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v1.21.7.0/s6-overlay-amd64.tar.gz | tar xzf - -C /

# build sks
curl -L -s https://github.com/SKS-Keyserver/sks-keyserver/releases/download/1.1.6/sks-1.1.6.tgz | tar xzf - -C /tmp/

cd /tmp/sks-*/
cp Makefile.local.unused Makefile.local
sed -i \
  -e 's/PREFIX=\/usr\/local/PREFIX=\/usr/' \
  -e 's/ldb\-4.6/ldb\-5/' \
  Makefile.local
sed -i \
  -e 's/ALL=$(EXE) sks.8.gz/ALL=$(EXE) #sks.8.gz/' \
  -e 's/ALL.bc=$(EXE:=.bc) sks.8.gz/ALL.bc=$(EXE:=.bc) #sks.8.gz/' \
  -e 's/mkdir -p $(MANDIR)\/man8/#mkdir -p $(MANDIR)\/man8/' \
  -e 's/install sks.8.gz $(MANDIR)\/man8/#install sks.8.gz $(MANDIR)\/man8/' \
  Makefile
patch -p1 < /tmp/patches/reject-poison-keys.diff
make dep && make all # this make stops cause ocaml 4.03 removes uint32
sed -i 's/uint32/uint32_t/' cryptokit-1.7/src/stubs-md5.c # this line fix uint32 issue
make all && make install
sed -i 's/#!\/bin\/bash/#!\/bin\/sh/' /usr/bin/sks_build.sh
sed -i 's/\/usr\/sbin\/sks/\/usr\/bin\/sks/' /usr/bin/sks_build.sh

# add startup scrips
chmod +x /tmp/run.sh /tmp/s6/services/.s6-svscan/finish /tmp/s6/services/sks-*/run
mv /tmp/run.sh /bin
mv /tmp/bin/* /bin
cp -rp /tmp/s6 /etc/

# remove build deps
apk --no-progress --purge del camlp4 db-dev gcc libc-dev make zlib-dev ocaml curl
rm -rf /root/.ash_history /tmp/* /var/cache/apk/*
