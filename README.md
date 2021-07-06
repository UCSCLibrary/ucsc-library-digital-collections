# UCSC Library Digital Collections Repository for Notch8 Development, Build and Deploy

**Note**: This is a copy of [UCSC's Library Digital Collections Repository](https://github.com/UCSCLibrary/ucsc-library-digital-collections) for use with Notch8 infrastructure deploys.


From [UCSC's Library Digital Collections Repository](https://github.com/UCSCLibrary/ucsc-library-digital-collections): 

> This Rails application is based on the Hyrax gem as part of the Samvera project. With Solr and Fedora it is meant to be used as a repository and access point for some of UCSC's digital collections. 
A basic Hyrax installation has been customized with our own metadata schema, styling, and some features that are specific to our instutition. We have developed our own batch ingest widget, and we integrate our samvera-hls gem for audiovisual transcoding and streaming. 
>
>This project is under heavy development.

## Docker Development Setup

**Note**: Docker setup is adapted from the original [UCSC digitial collections development setup](https://github.com/UCSCLibrary/digital_collections_dev_docker) with a few modifications to work with this version of the repo and enable to deploys to N8 staging infrastructure.

### Prerequisites
- Docker

## Setting up your development environment

### Clone repositories and set up directory structure

This project relies on a specific directory structure in order for it to reliably spin up.

```bash
# Make a directory for UCSC project
> mkdir ucsc-dc && cd ucsc-dc
# Clone the digital collections repo and put it in a `hyrax` directory
> git clone git@github.com:UCSCLibrary/digital_collections_dev_docker.git hyrax
# Clone the Docker setup and put it in `docker` directory`
> git clone git@github.com:UCSCLibrary/digital_collections_dev_docker.git docker

# Clone the rest of the dependencies and place into respective folders
> git clone git@github.com:UCSCLibrary/bulkops.git bulk_ops
> git clone git@github.com:UCSCLibrary/scoobysnacks.git scooby_snacks
> git clone git@github.com:UCSCLibrary/samvera_hls.git samvera_hls

# Install and unzip fits library (Samvera requirement)
> wget https://github.com/harvard-lts/fits/releases/download/1.5.0/fits-1.5.0.zip # You may need to install wget (`brew update && brew install wget`)
> unzip fits-1.5.0.zip
> fits-1.5.0 fits
> rm fits-1.5.0.zip

# Create additional asset folders
> mkdir dams_ingest
> mkdir dams_derivatives

# Create development env file
> touch .env.development

# Start Docker from within `docker` directory
> cd docker
> docker-compose up
```

It may take a few minutes for the app to start up. When the **hycruz** logs '`Listening on tcp://0.0.0.0:3000`', navigate to `http://localhost:3000` in your browser to view the site.

### Edit private configuration files
All configuration is done in .env.development.  Currently defaults can be found in .env, but items in .env.development can be used to override these values.

## Setting the N8 remote
While you will be working from [UCSC's Library Digital Collections Repository](https://github.com/UCSCLibrary/ucsc-library-digital-collections), you'll need to push  commits to this repository in order to build and deploy to N8 staging infrastructure. For this, you will need to set up an `n8` remote in git.

**To set up `n8` remote**

In another terminal window/pane:
- `cd` into the `hyrax` directory
- `git remote add n8 git@gitlab.com:notch8/ucsc-library-digital-collections.git`
- Confirm your remote is set up by running `git remote get-url n8`
    - If set correctly, it will return: `git@gitlab.com:notch8/ucsc-library-digital-collections.git`

## Development
Once your project directories and remotes are set up, you are set to develop.

**A couple of key things to keep in mind**:
- The `docker` directory contains the docker setup. You will always run `docker-compose up` from here
- The `hyrax` directory contains project code that you will edit and commit

**Workflows**

Here is the general workflow you'll start with. (Please edit this when/if requirements change or a better workflow is determined)

- Create a branch
- Edit
- Commit
- `git push n8 <branch-name> ` to push to N8 
- Merge to default branch (`n8-staging`) to trigger staging deploy
- When approved in Notch8 QA, make an **MR** against `origin` (using your original, pre n8-staging merge  **MR**)

## Log in to a repl on the dev site
If you need a repl on the dev site, first log in to the webapp container: `docker exec -it hycruz bash`. Then you can just enter `repl` to activate a shortcut I created to set the bundle parameters correctly and start the repl.