.PHONY: test clean upload versions

SHELL = bash

polygon_dir := $(shell mktemp -d)

# required: bash, (any) python, pip, virtualenv
# optional: python2, python3, gnu coreutils
versions:
	@echo Versions used:
	@echo ----
	@bash --version | head -1
	@echo Default Python: $$(python -V 2>&1)
	@python2 -V || true
	@python3 -V || true
	@pip -V
	@echo VirtualEnv: $$(virtualenv --version)
	@dpkg-query -W coreutils || true
	@pkg query %n-%v coreutils || true
	@echo ----

test: versions tests_setup tests tests_teardown

tests_setup: tests/global_setup.sh
	@if [ -x "$<" ]; then env -i polygon_dir=${polygon_dir} bash "$<"; fi

tests_teardown: tests/global_teardown.sh
	@if [ -x "$<" ]; then env -i polygon_dir=${polygon_dir} bash "$<"; fi

test_%: tests/test_%
	@env -i TERM=$$TERM polygon_dir=${polygon_dir} bash "$<"

tests: $(patsubst tests/%,%,$(wildcard tests/test_*))

upload:
	python setup.py sdist bdist_wheel upload

clean:
	rm -rf build/ dist/ *.egg-info/
