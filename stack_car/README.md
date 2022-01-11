[Docker development setup](#docker-development-setup)

[Bash into the container](#bash-into-the-container)

[Handling Secrets with SOPS](#handling-secrets-with-sops)

[Deploy a new release](#deploy-a-new-release)
  
[Run import from admin page](#run-import-from-admin-page)

# Docker development setup

We recommend committing .env to your repo with good defaults. .env.development, .env.production etc can be used for local overrides and should not be in the repo. See [Handling Secrets with SOPS](#handling-secrets-with-sops) for how to manage secrets.

1) Install Docker.app

2) Install stack car
    ``` bash
    gem install stack_car
    ```

3) Sign in with dory
    ``` bash
    dory up
    ```

4) Install dependencies
    ``` bash
    yarn install
    ```

5) Start the server
    ``` bash
    sc up
    ```

6) Load and seed the database
    ``` bash
    sc be rake db:migrate db:seed
    ```
    
7) Visit the running instance in the browser at `project-name.test`

### Troubleshooting Docker Development Setup
Confirm or configure settings. Sub your information for the examples.
``` bash
git config --global user.name example
git config --global user.email example@example.com
docker login registry.gitlab.com
```

### While in the container you can do the following
- Run rspec
    ``` bash
    bundle exec rspec
    ```
- Access the rails console
    ``` bash
    bundle exec rails c
    ```

### Handling Secrets with SOPS

[**SOPS**](https://github.com/mozilla/sops) is used to handle this project's secrets.

The secrets in this repository include:
- `.env*` files
- `*-values.yaml` files

Scripts (`bin/decrypt-secrets` and `bin/encrypt-secrets`) are included in this project to help with managing secrets.

**To decrypt secrets**:

You will need to do this if you are new to the project or there have been changes to any secrets files that are required for development.

In terminal:
```bash
bin/decrypt-secrets
```

This will find and decrypt files with the `.enc` extension.

**To encrypt secrets**:

You will need to do this when you have edited secrets and are ready to commit them.

In terminal:
```bash
bin/encrypt-secrets
```

This will find and output an encrypted version of secret files with an `.enc` extension.

# Deploy a new release

``` bash
sc release {staging | production} # creates and pushes the correct tags
sc deploy {staging | production} # deployes those tags to the server
```

Release and Deployment are handled by the gitlab ci by default. See ops/deploy-app to deploy from locally, but note all Rancher install pull the currently tagged registry image
