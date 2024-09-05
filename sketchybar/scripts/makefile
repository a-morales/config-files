all: bin
	(cd menus && $(MAKE)) >/dev/null
	(cd cpu_load && $(MAKE)) >/dev/null
	(cd network_load && $(MAKE)) >/dev/null

bin:
	mkdir bin

clean:
	rm -rf bin
