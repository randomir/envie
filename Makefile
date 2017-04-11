.PHONY: test clean upload

test_%: tests/test_%
	@env -i TERM=$$TERM bash "$<"

test: $(patsubst tests/%,%,$(wildcard tests/test_*))

upload:
	python setup.py sdist bdist_wheel upload

clean:
	rm -rf build/ dist/ *.egg-info/
