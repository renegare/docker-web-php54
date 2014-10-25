all: build push

build:
	docker build -t renegare/docker-web-php54:latest .

push:
	docker push renegare/docker-web-php54
