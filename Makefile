.SILENT:
.PHONY: help

## Colors
COLOR_RESET   = \033[0m
COLOR_INFO    = \033[32m
COLOR_COMMENT = \033[33m
COLOR_ERROR   = \033[31m

## Defaults
template = debian-7-amd64
type     = vagrant
version  = 1.0.2

## Help
help:
	printf "${COLOR_COMMENT}Usage:${COLOR_RESET}\n"
	printf " make [target] template=[template] type=[type] version=[version]\n\n"
	printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	awk '/^[a-zA-Z\-\_0-9\.]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf " ${COLOR_INFO}%-16s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	printf "\n${COLOR_COMMENT}Available templates:${COLOR_RESET}\n"
	printf " ${COLOR_INFO}debian-7-amd64         ${COLOR_RESET} Debian 7 (Wheezy) Amd64\n"
	printf " ${COLOR_INFO}debian-8-amd64         ${COLOR_RESET} Debian 8 (Jessie) Amd64\n"
	printf " ${COLOR_INFO}symfony-standard-debian${COLOR_RESET} Symfony Standard\n"
	printf "\n${COLOR_COMMENT}Available types:${COLOR_RESET}\n"
	printf " ${COLOR_INFO}vagrant${COLOR_RESET} Vagrant\n"
	printf " ${COLOR_INFO}docker ${COLOR_RESET} Docker\n"

## Build
build: clean roles
ifeq (${type}, docker)
	TMPDIR=~/tmp/packer packer build -only=docker -var 'ansible_user=docker packer_builder=docker version=${version}' debian/${template}/template.json
else
	packer build -only=virtualbox-iso -var 'ansible_user=vagrant packer_builder=virtualbox-iso version=${version}' debian/${template}/template.json
endif

## Test
test:
ifeq (${type}, docker)
   docker run -d -p 0.0.0.0:2225:22 -t -i elao/${template} /bin/sh -c '/usr/sbin/sshd -D'
else
	printf "${COLOR_INFO}Add vagrant box ${COLOR_RESET}\n"
	vagrant box add ${template}-${version}-virtualbox.box --name ${template} --force
endif

## Publish
publish:
ifeq (${type}, docker)
	printf "${COLOR_INFO}Push dockr image ${COLOR_RESET}\n"
	cat ${template}-${version}-docker.tar | docker import - elao/${template}:latest
	docker push elao/${template}
else
	printf "${COLOR_INFO}Upload vagrant box ${COLOR_RESET}\n"
	scp ${template}-${version}-virtualbox.box boxes.elao.com:/var/www/boxes/vagrant
endif

## Clean
clean:
	printf "${COLOR_INFO}Clean output files ${COLOR_RESET}\n"
	rm -Rf output-*

## Roles
roles:
	printf "${COLOR_INFO}Install ${COLOR_RESET}${template}${COLOR_INFO} ansible galaxy roles into ${COLOR_RESET}debian/${template}/ansible/roles:\n"
ifeq (${template}, symfony-standard-debian)
	ansible-galaxy install -f -r debian/debian-7-amd64/ansible/roles.yml -p debian/debian-7-amd64/ansible/roles
	ansible-galaxy install -f -r debian/symfony-standard-debian/ansible/roles.yml -p debian/symfony-standard-debian/ansible/roles
else
	ansible-galaxy install -f -r debian/${template}/ansible/roles.yml -p debian/${template}/ansible/roles
endif
