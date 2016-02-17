#!/bin/sh

apt-get update && \
	apt-get install -y autoconf bison build-essential ca-certificates curl git python-pip sudo \
	libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
pip install awscli
