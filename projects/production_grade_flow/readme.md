# Project

Generate a project using `npx`

```shell
npx create-react-app frontend
```

## Local Build

```shell
docker build -f dockerfile.name .

# should really use tags
docker build -f dockerfile.name -t frontend .
```

## Local Testing

Tests can be run either by connecting standard in to an already existing container...

```shell
docker run container

# New tab
docker exec -it container
npm run test
```

### Using Docker Compose locally

`docker compose up`

The [docker-compose.yml](./docker-compose.yml) uses secrets passed from the command line. If you have to `sudo` to run docker then append `-E` to the command to pass the environment variables from your session. e.g. `sudo -E docker compose up -d`. Use [create_environment_variables.sh](./scripts/create_environment_variables.sh) to set environment variables sourced from Key Vault or Git Hub.

#### Redis

You may need to run `sysctl vm.overcommit_memory=1` in your console.

## Azure DevOps Project / GitHub Account

### Prerequisites

#### Github

[GitHub Cli](https://cli.github.com/)

#### Azure DevOps

[Az cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?view=azure-cli-latest&pivots=apt)

### Github Secrets

Create github secrets to login into DockerHub

```shell
# Syntax
gh secret set NAME -b "secret value" -r "repo name"

gh secret set DOCKER_PASSWORD -b "" -r "account_name/repo_name"
```

### Azdo Library Variables

Create a repo in your AzDo Project or GitHub account...

### Repository

Create a repository within your Azure DevOps project or GitHub Account.

Once the repo is created you can either clone the repo...

```shell
git clone git@ssh.dev.azure.com:v3/{org_name}/{project_name}/{repo_name}
```

or

```shell
git clone git@github.com:{account_name}/{repo_name}.git
```

or create it locally and link to the origin...

```shell
# Initialise a readme or some other file
echo "# Repo Name" >> readme.md
git init
git add readme.md
git commit -m "Initial commit"
git remote add origin git@github.com:{account_name}/{repo_name}.git
git push -u origin {main_branch_name}
```