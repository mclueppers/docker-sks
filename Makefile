DOCKER_USER := mclueppers
DOCKER_ORGANIZATION := mclueppers
DOCKER_IMAGE := sks

docker-image:
	docker build -t $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE) .

docker-image-test: docker-image
	docker run --rm $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE) /usr/bin/sks version

ci-test: docker-image-test

run:
	@docker run \
	-d \
	-v /opt/services/sks:/var/lib/sks \
	-p 21371:11371 \
	-p 21370:11370 \
	-e "SKS_HOSTNAME=keyserver.dobrev.eu" \
	-e "SKS_NODENAME=node01.keyserver.dobrev.eu" \
	$(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE)
	@docker run \
	-d \
	-v /opt/services/sks2:/var/lib/sks \
	-p 22371:11371 \
	-p 22370:11370 \
	-e "SKS_HOSTNAME=keyserver.dobrev.eu" \
	-e "SKS_NODENAME=node02.keyserver.dobrev.eu" \
	$(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE)

.PHONY: docker-image docker-image-test ci-test
# vim:ft=make
