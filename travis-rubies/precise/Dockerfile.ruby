FROM ubuntu:precise

RUN apt-get update && \
	apt-get install -y autoconf bison build-essential ca-certificates curl git python-pip sudo \
	libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
RUN pip install awscli
RUN apt-get install -y openjdk-7-jre-headless

ARG UPLOAD=s3://hetznerza/travis-ci/precise/no-rvm
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION=eu-west-1
ARG TRUBY
ARG TOPENSSL

WORKDIR /tmp

RUN [ "$TOPENSSL" = "none" ] || \
	curl https://s3-eu-west-1.amazonaws.com/hetznerza/travis-ci/precise/no-rvm/openssl-${TOPENSSL}.tar.gz | tar -C /opt -xzf -

RUN mkdir -p /opt/rubies
RUN git clone https://github.com/rbenv/ruby-build.git && \
	cd ruby-build && sudo ./install.sh

RUN RUBY_CONFIGURE_OPTS=--with-openssl-dir=/opt/openssl-${TOPENSSL} ruby-build -v ${TRUBY#ruby-} /opt/rubies/${TRUBY}

# First, just make sure the container's CA cert store is up to date
RUN curl https://www.howsmyssl.com/a/check

# Now test the ruby we've built
RUN git clone https://github.com/postmodern/chruby.git
RUN cd chruby && sudo ./scripts/setup.sh
ENV SHELL=/bin/bash
RUN chruby-exec ${TRUBY} -- ruby --version
RUN chruby-exec ${TRUBY} -- gem install --no-ri --no-rdoc bundler
RUN chruby-exec ${TRUBY} -- ruby --version
RUN git clone https://github.com/sheldonh/travis-custom-ruby-test.git
RUN cd travis-custom-ruby-test && chruby-exec ${TRUBY} -- bundle
RUN cd travis-custom-ruby-test && chruby-exec ${TRUBY} -- bundle exec rake

# Ship it
RUN tar -C /opt/rubies -czf ${TRUBY}.tar.gz ${TRUBY}
RUN aws s3 cp --acl=public-read ${TRUBY}.tar.gz ${UPLOAD}/${TRUBY}.tar.gz

CMD /bin/bash
