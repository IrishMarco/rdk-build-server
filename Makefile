build:
	@docker pull ubuntu:16.04
	@docker build -t irishmarco/rdk-build-server .
