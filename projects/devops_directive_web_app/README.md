# DevOps Directive Docker Course

## Development

```shell
docker compose -f docker-compose-dev.yml up
```

The [docker-compose.yml](./docker-compose-dev.yml) uses secrets passed from the command line. If you have to `sudo` to run docker then append `-E` to the command to pass the environment variables from your session. e.g. `sudo -E docker compose -f docker-compose-dev.yml up -d`.

Use [create_environment_variables.sh](../../scripts/create_environment_variables.sh) to set environment variables sourced from Key Vault or Git Hub.

### Debugging

You can attach vs code to the Node API container using port 9229 and Go API container using Delve and port 4000.

```shell
docker compose -f docker-compose-dev.yml -f docker-compose-debug.yml up
```

## Test

You execute the tests defined within each application code repo on the containers using docker compose.

```shell
docker compose -f docker-compose-dev.yml -f docker-compose-test.yml run --build api-golang
```

```text
...
?       api-golang      [no test files]
?       api-golang/database     [no test files]
?       api-golang/healthcheck  [no test files]
=== RUN   TestOneEqualsOne
--- PASS: TestOneEqualsOne (0.00s)
PASS
ok      api-golang/tests        0.003s
```

```shell
docker compose -f docker-compose-dev.yml -f docker-compose-test.yml run --build api-node
```

```text
...

> api-node@1.0.0 test
> jest

 PASS  tests/example.test.js
  ✓ This is a test that always passes (5 ms)

Test Suites: 1 passed, 1 total
Tests:       1 passed, 1 total
Snapshots:   0 total
Time:        0.979 s
Ran all test suites.
```

## Prod

...
