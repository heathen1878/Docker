# IAC

## Prerequsities

### Github

[GitHub Cli](https://cli.github.com/)

### Github Variables

Create github variables to set the Terraform backend

```shell
# Example syntax
gh variable set NAME -b "secret value" -r "repo name"

gh variable set TERRAFORM_VERSION -b "core executable version e.g. 1.9.3" -r account_name/repo_name
gh variable set STATE_STORAGE_ACCOUNT -b storage_account_name -r "account_name/repo_name"
gh variable set STATE_STORAGE_CONTAINER -b state_storage_container -r "account_name/repo_name"
gh variable set STATE_FILE_NAME -b state_file_name -r "account_name/repo_name"
```

### Github Secrets

Create github secrets to authenticate with Azure

```shell
gh secret set AZURE_CREDENTIALS -b "{"clientId": "<Client ID>","clientSecret": "<Client Secret>","subscriptionId": "<Subscription ID>","tenantId": "<Tenant ID>"}" -r "account_name/repo_name"
```
