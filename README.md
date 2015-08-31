# Packer Templates

## Requirements

  - packer >= 0.8.6

### Vagrant

  - vagrant >= 1.7.4
  - ansible >= 1.9.2

### Docker

  - docker >= 1.8.1
  - docker-machine >= 0.4.1

## Usage

    $ make [target] template=[template] type=[type] version=[version]

Examples:

    # Build debian-7-amd64 on vagrant
    $ make build template=debian-7-amd64 type=vagrant
    # Build symfony-standard-debian on vagrant
    $ make build template=symfony-standard-debian type=vagrant
    # Build debian-7-amd64 on docker
    $ make build template=debian-7-amd64 type=docker
    # Test debian-7-amd64 on vagrant
    $ make test template=debian-7-amd64 type=vagrant
    # Publish debian-7-amd64 on vagrant
    $ make publish template=debian-7-amd64 type=vagrant
