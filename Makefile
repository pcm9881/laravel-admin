up:
	@echo "Docker Compose Up"
	-docker-compose up -d
down:
	@echo "Docker Compose Down"
	-docker-compose down
docker-clean:
	@echo "Remove all non running containers"
	-docker rm `docker ps -q -f status=exited`
	@echo "Delete all untagged/dangling (<none>) images"
	-docker rmi `docker images -q -f dangling=true`
