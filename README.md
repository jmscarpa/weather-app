# Weather App

Rails app that fetches geocoded locations and current weather data.

## Requirements

- Ruby 3.4.8 (see .ruby-version)
- Node.js and Yarn
- SQLite3

## Configuration

This app uses Rails credentials for API keys.
Add the key sent to you through email to `config/credentials.yml.enc`:

## Run locally

```bash
bin/setup
bin/dev
```

Visit http://localhost:3000

## Run with Dev Container

1. In VS Code, run the command: "Dev Containers: Reopen in Container".
2. Wait for the container to finish running `bin/setup --skip-server`.
3. Start the app in the container:

```bash
bin/dev
```

The container forwards port 3000. Open http://localhost:3000.

## Run tests

```bash
bundle exec rspec
```
