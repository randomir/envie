.PHONY: clean upload

upload:
	python setup.py sdist bdist_wheel upload

clean:
	rm -rf build/ dist/ *.egg-info/
