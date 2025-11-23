# AutonomOS

AutonomOS is a starter operating system designed for general-purpose embedded Linux systems. It provides a minimal environment with feature classes to enable the most general and common use cases, and integrates Mender support for OTA updates.

## Hardware Support

AutonomOS currently supports the following hardware platforms:

- Raspberry Pi 5
- Raspberry Pi Zero 2 W
- BeagleBone Blue

## Features

- Containerization with Docker
- Kubernetes
- Development variants with additional shell tools, such as vim and tmux

## Getting Started

To get started with AutonomOS, create a Kas configuration file based on the `reference.yaml` file and `secrets.yaml.tmpl` template provided in this repository. Customize the configuration as needed for your specific hardware and requirements. Additional features and machines are available in the `includes` directory.
