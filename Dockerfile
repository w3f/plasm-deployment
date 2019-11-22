FROM rustlang/rust:nightly-stretch-slim as builder

RUN apt update && \
  apt install -y --no-install-recommends cmake git clang libclang-dev pkg-config libssl-dev build-essential

RUN rustup target add wasm32-unknown-unknown --toolchain nightly

RUN cargo +nightly install --git https://github.com/alexcrichton/wasm-gc

RUN cargo install --force --git https://github.com/stakedtechnologies/Plasm --tag v0.5.0

FROM debian:stretch

COPY --from=builder /usr/local/cargo/bin/plasm-node /usr/local/bin/polkadot

RUN apt update && \
  apt install -y --no-install-recommends ca-certificates

RUN mv /usr/share/ca* /tmp && \
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
