all: build image

BUILD_TARGET = build/go-say-hello
IMAGE_TAG    = go-say-hello

clean:
	@rm $(BUILD_TARGET)

build: $(BUILD_TARGET)

$(BUILD_TARGET): hello.go
	docker run --rm -v `pwd`:/usr/src/myapp -w /usr/src/myapp golang:alpine go build -o $@ $^

image:
	docker build -t $(IMAGE_TAG) .
