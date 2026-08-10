bin/menubar: main.m | bin
	clang -O3 -F/System/Library/PrivateFrameworks/ -framework Foundation -framework Cocoa -framework Carbon -framework ApplicationServices -framework SkyLight $< -o $@

bin:
	mkdir bin
