.PHONY: test clean upload

polygon_dir := $(shell mktemp -d)

test: tests_setup tests tests_teardown

tests_setup: tests/global_setup.sh
	@if [ -x "$<" ]; then polygon_dir=${polygon_dir} exec "$<"; fi

tests_teardown: tests/global_teardown.sh
	@if [ -x "$<" ]; then polygon_dir=${polygon_dir} exec "$<"; fi

test_%: tests/test_%
	@env -i TERM=$$TERM polygon_dir=${polygon_dir} bash "$<"

tests: $(patsubst tests/%,%,$(wildcard tests/test_*))

upload:
	python setup.py sdist bdist_wheel upload

clean:
	rm -rf build/ dist/ *.egg-info/
