.PHONY: test clean upload

test: tests_setup tests tests_teardown

tests_setup:
	@[ -x tests/global_setup ] && ./tests/global_setup || true

tests_teardown:
	@[ -x tests/global_teardown ] && ./tests/global_teardown || true

test_%: tests/test_%
	@env -i TERM=$$TERM bash "$<"

tests: $(patsubst tests/%,%,$(wildcard tests/test_*))

upload:
	python setup.py sdist bdist_wheel upload

clean:
	rm -rf build/ dist/ *.egg-info/
