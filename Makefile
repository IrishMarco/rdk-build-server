build:
	@docker pull ubuntu:14.04
	@docker build -t arris/rdk-ubuntu:14.04 --build-arg ubuntu_ver=14.04 .
	@docker pull ubuntu:16.04
	@docker build -t arris/rdk-ubuntu:16.04 --build-arg ubuntu_ver=16.04 .
	@docker pull ubuntu:18.04
	@docker build -t arris/rdk-ubuntu:18.04 --build-arg ubuntu_ver=18.04 .
