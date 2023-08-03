.PHONY: start-dev build-prod frontend bootstrap clean lint test
.DEFAULT_GOAL := test

test: frontend lint
	@py.test test/ --cov=./main.py -s

lint:
	@flake8 .

clean:
	@find . -type f -name '*.pyc' -delete

bootstrap:
	@pip install -r requirements.txt
	@pip install -r requirements-test.txt
	@python setup.py develop
	@yarn install

build-prod: bootstrap
	@yarn webpack --mode production

start-dev:
	@yarn webpack --mode development --watch & ./venv/bin/python3 ./app/main.py

install: build-prod
	@mkdir -p /opt/resume
	@cp -a ./app/* /opt/resume
	@cp resume.service /etc/systemd/system/resume.service
	@systemctl enable resume.service
	@systemctl start resume.service

uninstall:
	systemctl stop resume.service
	systemctl disable resume.service
	@rm /etc/systemd/system/resume.service
