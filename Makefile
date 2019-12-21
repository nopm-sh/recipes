test:
	./test.sh

lint:
	find . -iname "*.sh" -exec shellcheck {} + || exit
	
test_docker_debian:
	docker build -f Dockerfile.debian.test -t test_docker_debian .
