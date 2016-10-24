# Geo Concerns
[![Build Status](https://img.shields.io/travis/projecthydra-labs/geo_concerns/master.svg)](https://travis-ci.org/projecthydra-labs/geo_concerns)
[![Coverage Status](https://img.shields.io/coveralls/projecthydra-labs/geo_concerns/master.svg)](https://coveralls.io/github/projecthydra-labs/geo_concerns?branch=master)
[![API Docs](http://img.shields.io/badge/API-docs-blue.svg)](http://www.rubydoc.info/github/projecthydra-labs/geo_concerns)
[![Gem Version](https://img.shields.io/gem/v/geo_concerns.svg)](https://github.com/projecthydra-labs/geo_concerns/releases)
[![Slack Status](http://slack.projecthydra.org/badge.svg)](https://project-hydra.slack.com/messages/geomodeling/)

Rails application for developing Hydra Geo models. Built around Curation Concerns engine.

* [Poster from Hydra Connect 2015](https://drive.google.com/file/d/0B5fLh2mc4FCbOUpWaTFOVmI4Nkk/view?pli=1)
* [Current GeoConcerns diagram](https://wiki.duraspace.org/download/attachments/69012114/pcdm-geo-model.pdf?version=1&modificationDate=1463590066822&api=v2)


## Dependencies

1. Solr
1. [Fedora Commons](http://www.fedora-commons.org/) digital repository
1. A SQL RDBMS (MySQL, PostgreSQL), though **note** that SQLite will be used by default if you're looking to get up and running quickly
1. [Redis](http://redis.io/), a key-value store
1. [ImageMagick](http://www.imagemagick.org/) with JPEG-2000 support
1. [GDAL](http://www.gdal.org/)
    * You can install it on Mac OSX with `brew install gdal`.
    * On Ubuntu, use `sudo apt-get install gdal-bin`.
1. [GeoServer](http://geoserver.org/) (Optional)

## Mapnik

GeoConcerns requires that Mapnik 3.x or 2.x be installed at `/usr/local/lib/libmapnik.*`. For linux, a C++ compiler and build environment is also needed.

Mac OS X:

- https://github.com/mapnik/mapnik/wiki/MacInstallation or ```brew install mapnik```

Linux:

- https://github.com/mapnik/mapnik/wiki/LinuxInstallation
- Build environment: [gcc](https://help.ubuntu.com/community/InstallingCompilers) or clang 

## Installation

Create and run a new GeoConcerns application from a template:

```
$ rails new app-name -m https://raw.githubusercontent.com/projecthydra-labs/geo_concerns/master/template.rb
$ cd app-name
$ rake hydra:server
```

Add GeoConcerns models to an existing CurationConcerns application:

1. Add `gem 'geo_concerns'` to your Gemfile.
1. `bundle install`
1. `rails generate curation_concerns:install`
1. `rails generate geo_concerns:install -f`

## Development

1. `bundle install`
2. `rake engine_cart:generate`
3. `rake geo_concerns:dev_servers`

## Testing

3. `rake ci`

To run tests separately:

```
$ rake geo_concerns:test_servers
```

Then, in another terminal window:

```
$ rake spec
```
To run a specific test:

```bash
rspec spec/path/to/your_spec.rb:linenumber
```

## Running GeoServer for Development with Docker

### MacOS

1. Make sure you have docker engine, docker-machine, and docker-compose installed.
   - Docker Toolbox: [https://www.docker.com/products/docker-toolbox](https://www.docker.com/products/docker-toolbox)

1. Execute the following command in the geo_concerns directory:
   
   ```
   $ source ./run-docker.sh
   ```
1. To stop the server and remove port forwarding:

	```
	$ docker-compose stop
	$ killall ssh
	```

### Linux

1. Make sure you have docker engine and docker-compose installed.
   - [https://docs.docker.com/engine/installation/linux/](https://docs.docker.com/engine/installation/linux/)
   - [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

1. Execute the following commands in the geo_concerns directory:

	```
	$ docker-compose up -d
	```

## Running GeoServer for Development with Vagrant

1. Make sure you have VirtualBox and Vagrant installed.
	- [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
	- [https://www.vagrantup.com/docs/installation/](https://www.vagrantup.com/docs/installation/)
1. Execute the following commands:
	
	```
	$ git clone https://github.com/geoconcerns/geoserver-vagrant.git
	$ cd geoserver-vagrant/
	$ vagrant up
	
	```
