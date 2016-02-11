#!/bin/sh

BUILDS=$(cat <<EOF
	ruby-2.0.0-p648:1.0.1d
	ruby-2.3.0:1.0.2f
	jruby-9.0.0.0:none
	jruby-9.0.4.0:none
EOF
)

for build in $BUILDS; do
	TRUBY=${build%:*}
	TOPENSSL=${build#*:}

	if [ "$TOPENSSL" != "none" ]; then
		echo Building openssl-$TOPENSSL

		docker build \
			--build-arg AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
			--build-arg AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
			--build-arg TRUBY=$TRUBY \
			--build-arg TOPENSSL=$TOPENSSL \
			-f Dockerfile.openssl \
			.
	else
		echo 'Skipping openssl (version set to none)'
	fi

	echo Building $TRUBY

	docker build \
		--build-arg AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
		--build-arg AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
		--build-arg TRUBY=$TRUBY \
		--build-arg TOPENSSL=$TOPENSSL \
		-f Dockerfile.ruby \
		.
done
