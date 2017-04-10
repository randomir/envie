.PHONY: test clean upload

test: tests/test_*
	@for test in $^; do env -i TERM=$$TERM bash "$$test"; done

upload:
	python setup.py sdist bdist_wheel upload

clean:
	rm -rf build/ dist/ *.egg-info/
