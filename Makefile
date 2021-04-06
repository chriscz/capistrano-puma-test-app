NAME = capistrano-puma-test
VERSION = 0.0.1
IMAGE_NAME=$(NAME):$(VERSION)

# EXTRA_BUILD_FLAGS?= --no-cache
EXTRA_BUILD_FLAGS?=

build:
	docker build . $(EXTRA_BUILD_FLAGS) -t $(IMAGE_NAME) #--rm

test: build ntest

ntest:
	docker run --rm -it $(IMAGE_NAME) /sbin/my_init -- su app -l -c 'cd /deploy/webapp && ./deploy.sh'
	# cd /tmp/webapp && ./deploy.sh

.PHONY=build test ntest
