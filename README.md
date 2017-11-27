# UCSC Library Digital Collections Repository

This Rails application is based on the Hyrax gem as part of the Samvera project. With Solr and Fedora it is meant to be used as a repository and access point for some of UCSC's digital collections. 
A basic Hyrax installation has been customized with our own metadata schema, styling, and some features that are specific to our instutition. We have developed our own batch ingest widget, and we integrate our samvera-hls gem for audiovisual transcoding and streaming. 

## Plans

This project is under heavy development. Here are a few of the changes currently in progress:

### Upgrade to Hyrax 2
The Samvera community has called for fewer released of the software, to let their developers have a stable base to work off of. Hyrax 2 has been proposed as the version that the community might commit to maintaining for several years. Therefore, upgrading to that version soon will serve us well in the next few years of development. 

### Major metadata schema changes
We are implementing a new metadata model similar to those used by UCSB and UCSD. This will be substantially different from our current model, and will require some new features to handle Fedora objects outside the PCDM (i.e. nested attributes). 
