#!/bin/sh -ex

if [ -z "${TOPENSSL}" ]; then echo "TOPENSSL environmenet variable missing"; exit 1; fi
if [ -z "${TRUBY}" ]; then echo "TRUBY environmenet variable missing"; exit 1; fi

work_dir=$(pwd)
ruby_version=${TRUBY#ruby-}
openssl_version=${TOPENSSL#openssl-}
ruby_dir=/opt/rubies/${TRUBY}
openssl_dir=${ruby_dir}/${TRUBY}/${TOPENSSL}

mkdir -p ${ruby_dir}

if [ "${TOPENSSL}" != "none" ]; then
	git clone https://github.com/openssl/openssl.git
	cd openssl
	git checkout OpenSSL_$(echo ${openssl_version} | tr . _)
	./config -fPIC --openssldir=${openssl_dir} shared
	make depend
	make
	make install

	cd ${openssl_dir}
	for i in certs private openssl.cnf; do
		rm -rf $i
		ln -s /etc/ssl/$i
	done
fi

cd ${work_dir}
git clone https://github.com/rbenv/ruby-build.git
cd ruby-build
./install.sh
RUBY_CONFIGURE_OPTS=--with-openssl-dir=${openssl_dir} ruby-build -v ${ruby_version} ${ruby_dir}

cd ${work_dir}
tar -C ${ruby_dir}/.. -czf ${TRUBY}.tar.gz ${TRUBY}
