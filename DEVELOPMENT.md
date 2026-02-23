# Development

## Recommended editor

VS Code configuration is part of the repo in `.vscode/extensions.json` and `.vscode/settings.json`.

## Helm unit tests

Install the helm-unittest plugin:
```bash
helm plugin install https://github.com/helm-unittest/helm-unittest
```

Conventions:
- Place test files under tests/ with suffix _test.yaml.
- Run from repo root against the chart directory (example: charts/neoload-web).

Common commands:
```bash
# Run all unit tests
helm unittest ./
```