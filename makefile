export PATH := $(CURDIR)/.venv/bin:$(PATH)

.PHONY: deps lint test

.venv/bin/pre-commit: pyproject.toml uv.lock
	uv venv --allow-existing .venv
	uv export --frozen --no-header --format requirements-txt | uv pip sync --python .venv/bin/python --require-hashes -
	touch $@

deps: .venv/bin/pre-commit
	pre-commit install --hook-type pre-commit --hook-type pre-push

lint: deps
	pre-commit run --all-files

test: deps
	tests/select-test.sh
