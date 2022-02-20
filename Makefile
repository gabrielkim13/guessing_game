all:
	cargo build --target=armv7-unknown-linux-gnueabihf

clean:
	rm -rf target/armv7-unknown-linux-gnueabihf
