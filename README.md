# UCSC Library Digital Collections

This Rails application is based on the Hyrax gem as part of the Samvera project. With Solr and Fedora it is meant to be used as a repository and access point for some of UCSC's digital collections. 
A basic Hyrax installation has been customized with our own metadata schema, styling, and some features that are specific to our instutition. We have developed our own batch ingest widget, and we integrate our samvera-hls gem for audiovisual transcoding and streaming. 

This project is under heavy development.

## Stack Car Development Setup

### Prerequisites
- Docker

## Setting up your development environment

### Clone repositories and set up directory structure

This project relies on a specific directory structure in order for it to reliably spin up.

```bash
# Make a directory for UCSC project
> mkdir digital-collections && cd digital-collections
# Clone the digital collections repo and put it in a `hyrax` directory
> git clone git@github.com:UCSCLibrary/ucsc-library-digital-collections.git hyrax

# Clone the rest of the dependencies and place into respective folders
> git clone git@github.com:UCSCLibrary/scoobysnacks.git scooby_snacks
> git clone git@github.com:UCSCLibrary/samvera_hls.git samvera_hls

# Install and unzip fits library (Samvera requirement)
> wget https://github.com/harvard-lts/fits/releases/download/1.5.0/fits-1.5.0.zip # You may need to install wget (`brew update && brew install wget`)
> mkdir fits
> unzip fits-1.5.0.zip -d fits
> rm fits-1.5.0.zip

# Create additional asset folders
> mkdir dams_ingest
> mkdir dams_derivatives

# Start the application using Stack Car
> cd hyrax; sc up
# or
> cd hyrax/stack_car; docker-compose up
```

It may take a few minutes for the app to start up. When the **hycruz** logs '`Listening on tcp://0.0.0.0:3000`', navigate to `http://localhost:3000` in your browser to view the site.

### Edit private configuration files
All configuration is done in .env.development.  Currently defaults can be found in .env, but items in .env.development can be used to override these values.

## Development
Once your project directories and remotes are set up, you are set to develop. The `hyrax` directory contains project code that you will edit and commit

**Workflows**

Here is the general workflow you'll start with. (Please edit this when/if requirements change or a better workflow is determined)

- Make sure sandbox is up-to-date: `git checkout sandbox; git fetch; git pull`
- Make a new branch from sandbox using the ticket number, ex: `git checkout -b 123-bug-fix`
- Make your changes and commit.
- `git push origin <branch-name> ` to push your new branch to github. 
- Create a pull request detailing the changes and link back to the ticket it resolves.
- Assign someone for code review.

## Log in to a repl on the dev site
If you need a repl on the dev site, first log in to the webapp container: `docker exec -it hycruz bash`. Then you can just enter `repl` to activate a shortcut I created to set the bundle parameters correctly and start the repl.
