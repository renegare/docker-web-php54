all: build

build:
	docker build --rm -t renegare/docker-web-php54:latest .

run:
	docker run --rm -it renegare/docker-web-php54:latest /bin/bash
