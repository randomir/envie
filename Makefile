.PHONY: upload

upload:
	python setup.py sdist bdist_wheel upload
