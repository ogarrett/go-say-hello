all: build image

build: bin/go-say-hello

bin/go-say-hello: hello.go
	docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:alpine go build -o $@ $^

image:
	docker build -t go-say-hello .
