build:
	@docker pull ubuntu:16.04
	@docker build -t irishmarc/rdk-build-server .
