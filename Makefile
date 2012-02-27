all: clean
	echo '#!/usr/bin/env node' >> tw.js
	coffee -p tw.coffee >> tw.js

clean:
	rm -rf ./tw.js

PHONY: all
