#! /bin/sh
#
# build.bash
# Copyright (C) 2017 Óscar García Amor <ogarcia@connectical.com>
#
# Distributed under terms of the MIT license.
#

# install run deps
apk -U --no-progress add db s6

# install build deps
apk --no-progress add camlp4 db-dev gcc libc-dev make zlib-dev

# extract software
cd /tmp/tgz
tar xzf sks-*.tgz

# build sks
cd /tmp/tgz/sks-*/
cp Makefile.local.unused Makefile.local
sed -i 's/PREFIX=\/usr\/local/PREFIX=\/usr/' Makefile.local
sed -i 's/ldb\-4.6/ldb\-5/' Makefile.local
sed -i 's/ALL=$(EXE) sks.8.gz/ALL=$(EXE) #sks.8.gz/' Makefile
sed -i 's/ALL.bc=$(EXE:=.bc) sks.8.gz/ALL.bc=$(EXE:=.bc) #sks.8.gz/' Makefile
sed -i 's/mkdir -p $(MANDIR)\/man8/#mkdir -p $(MANDIR)\/man8/' Makefile
sed -i 's/install sks.8.gz $(MANDIR)\/man8/#install sks.8.gz $(MANDIR)\/man8/' Makefile
make dep && make all # this make stops cause ocaml 4.03 removes uint32
sed -i 's/uint32/uint32_t/' cryptokit-1.7/src/stubs-md5.c # this line fix uint32 issue
make all && make install
sed -i 's/#!\/bin\/bash/#!\/bin\/sh/' /usr/bin/sks_build.sh
sed -i 's/\/usr\/sbin\/sks/\/usr\/bin\/sks/' /usr/bin/sks_build.sh

# add startup scrips
chmod +x /tmp/run.sh /tmp/s6/.s6-svscan/finish /tmp/s6/*/run
mv /tmp/run.sh /bin
mv /tmp/s6 /etc

# remove build deps
apk --no-progress del camlp4 db-dev gcc libc-dev make zlib-dev
rm -rf /root/.ash_history /tmp/* /var/cache/apk/*
