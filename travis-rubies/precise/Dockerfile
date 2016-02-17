FROM ubuntu:precise

RUN apt-get update && \
	apt-get install -y autoconf bison build-essential ca-certificates curl git python-pip sudo \
	libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
RUN pip install awscli
RUN apt-get install -y openjdk-7-jre-headless

WORKDIR /tmp

ADD build-dependencies.sh /tmp
RUN ./build-dependencies.sh

ARG UPLOAD=s3://hetznerza/travis-ci/precise/no-rvm
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION=eu-west-1
ARG TRUBY
ARG TOPENSSL

ADD build.sh /tmp
RUN ./build.sh

# Ship it
RUN tar -C /opt/rubies -czf ${TRUBY}.tar.gz ${TRUBY}
RUN aws s3 cp --acl=public-read ${TRUBY}.tar.gz ${UPLOAD}/${TRUBY}-${TOPENSSL}.tar.gz

CMD /bin/bash
