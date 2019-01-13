FROM alpine:3.8

ENV OTP_VER="21.2"
ENV ELX_VER="1.7.4"

# Build OTP
RUN apk upgrade && \
	apk add build-base autoconf ncurses-dev git \
		zlib-dev libressl-dev ncurses-libs zlib && \
	cd ~ && \
	git clone https://github.com/erlang/otp && \
	cd otp && \
	git checkout tags/OTP-$OTP_VER && \
	./otp_build autoconf && \
	./configure --prefix=/opt/otp && \
	make -j$(nproc) && \
	make install && \
	rm -rf ~/*

# Add OTP to PATH

# Build elixir
RUN cd ~ && \
	git clone https://github.com/elixir-lang/elixir && \
	cd elixir && \
	git checkout tags/v$ELX_VER && \
	make -j$(nproc) && \
	make DESTDIR="/opt/elixir" install && \
	rm -rf ~/*
