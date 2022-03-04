.PHONY: build default serve all
.ONESHELL:

default: all 

all: clean build 

build:
	static --content-path ./markdown --output-path ./output --static-path ./static --template ./template/default.eex
	make -C css

serve:
	python -m http.server --directory ./output

clean:
	rm -r ./output/ || true

wait:
	while true;
	do inotifywait -re modify ./markdown;
	make all;
	done;

