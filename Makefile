.PHONY: build default serve
.ONESHELL:

default: clean build 

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
	make;
	done;

wait_template:
	while true;
	do inotifywait -e modify ./template/default.eex;
	make;
	done;

wait_css:
	while true;
	do inotifywait -re modify ./css;
	make;
	done;
