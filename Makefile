.PHONY: check lint-json lint-md

check: lint-json lint-md
	@echo "All checks passed."

lint-json:
	@echo "Linting JSON files..."
	@find . -name "*.json" -not -path "./.git/*" | while read f; do \
		python3 -m json.tool "$$f" > /dev/null 2>&1 && echo "  OK: $$f" || { echo "  FAIL: $$f"; exit 1; }; \
	done

lint-md:
	@echo "Linting Markdown files..."
	npx markdownlint-cli2 "**/*.md"
