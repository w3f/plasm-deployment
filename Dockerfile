FROM ubuntu:bionic

RUN apt update && \
  apt install -y --no-install-recommends ca-certificates wget && \
  wget https://github.com/w3f/plasm/releases/download/v0.5.0/plasm-node -O /usr/local/bin/polkadot  && \
  chmod a+x /usr/local/bin/polkadot && \
  mv /usr/share/ca* /tmp && \
	rm -rf /usr/share/*  && \
	mv /tmp/ca-certificates /usr/share/ && \
	rm -rf /usr/lib/python* && \
	useradd -m -u 1000 -U -s /bin/sh -d /polkadot polkadot && \
	mkdir -p /polkadot/.local/share/polkadot && \
	chown -R polkadot:polkadot /polkadot/.local && \
	ln -s /polkadot/.local/share/polkadot /data && \
	rm -rf /usr/bin /usr/sbin

USER polkadot
EXPOSE 30333 9933 9944
VOLUME ["/data"]

CMD ["/usr/local/bin/polkadot"]
