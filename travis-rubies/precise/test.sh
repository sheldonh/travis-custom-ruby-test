#!/bin/sh -ex

if [ -z "${TRUBY}" ]; then echo "TRUBY environmenet variable missing"; exit 1; fi

work_dir=$(pwd)

cd ${work_dir}
git clone https://github.com/postmodern/chruby.git
cd chruby
./scripts/setup.sh

cd ${work_dir}
git clone https://github.com/sheldonh/travis-custom-ruby-test.git
cd travis-custom-ruby-test
SHELL=/bin/bash chruby-exec ${TRUBY} -- ruby --version
SHELL=/bin/bash chruby-exec ${TRUBY} -- gem install --no-ri --no-rdoc bundler
SHELL=/bin/bash chruby-exec ${TRUBY} -- ruby --version
SHELL=/bin/bash chruby-exec ${TRUBY} -- bundle
SHELL=/bin/bash chruby-exec ${TRUBY} -- bundle exec rake
