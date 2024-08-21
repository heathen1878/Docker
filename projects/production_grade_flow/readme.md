# Project

Generate a project using `npx`

```shell
npx create-react-app frontend
```

## Build

```shell
docker build -f dockerfile.name .

# should really use tags
docker build -f dockerfile.name -t frontend .
```

## Tests

Tests can be run either by connecting standard in to an already existing container...

```shell
docker run container

# New tab
docker exec -it container
npm run test
```

### Using Docker Compose

`docker compose up`

## Azure DevOps Project / GitHub Account

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

### Pipelines

Azure DevOps -> Project -> Repository -> Branch -> CI Pipeline...

## Dev Phase

Feature Branch -> PR -> ...

## Testing Phase

CI Pipeline to run tests -> ...

## Production Phase

Merge PR -> Main Branch...