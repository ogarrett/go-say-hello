all: image

BUILD_TARGET = obj/go-say-hello
BUILD_DATE   = $(shell date +%Y/%m/%d-%H:%M:%S)
IMAGE_NAME   = go-say-hello
DOCKER_REPO  = ghcr.io/ogarrett
SRCS         = hello.go

# Specify version as 'make RELEASE=1.2.3 release'. Makefile will store current 
# release number in .release
# If RELEASE is not supplied, read from .release and increment last part
RELEASE	     = ${shell cat .release | perl -pe 's/(.*?)(\d+)$$/$$1.($$2+1)/e'}



clean:
	-@rm $(BUILD_TARGET)
	docker container prune --force


.PHONY: obj

obj: $(BUILD_TARGET)

$(BUILD_TARGET): $(SRCS)
	-@[ ! -d obj/ ] && mkdir obj/ 
	docker run --rm -v `pwd`:/usr/src/myapp -w /usr/src/myapp golang:alpine \
		go build -ldflags "-X main.BuildDate=$(BUILD_DATE) -X main.Release=$(RELEASE)" \
		-o $@ $^

image: obj
	docker build -t $(IMAGE_NAME) .
	@echo "    'make test' to test"
	@echo "    'make release' to push"

test: image
	docker run -d -p 8080:8080 --name="$(IMAGE_NAME)" $(IMAGE_NAME)
	@echo "    Running on port 8080"
	@echo "    'make stop' to halt"

stop:
	docker stop $(IMAGE_NAME)
	docker rm $(IMAGE_NAME)


release: image
	echo "Build number $(RELEASE)"
	docker tag $(IMAGE_NAME) $(DOCKER_REPO)/$(IMAGE_NAME):$(RELEASE) 
	docker image push $(DOCKER_REPO)/$(IMAGE_NAME):$(RELEASE)
	echo $(RELEASE) > .release
