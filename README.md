# Geo Concerns
[![Build Status](https://travis-ci.org/jrgriffiniii/pcdm-geo-models.svg?branch=jrgriffiniii-issue-8)](https://travis-ci.org/jrgriffiniii/pcdm-geo-models)
[![Coverage Status](https://coveralls.io/repos/jrgriffiniii/pcdm-geo-models/badge.svg?branch=jrgriffiniii-issue-8&service=github)](https://coveralls.io/github/jrgriffiniii/pcdm-geo-models?branch=jrgriffiniii-issue-8)
[![API Docs](http://img.shields.io/badge/API-docs-blue.svg)](http://rubydoc.info/github/jrgriffiniii/pcdm-geo-models)

Rails application for developing Hydra Geo models. Built around Curation Concerns engine.

## Installation

Execute:

```
    $ bundle
```

Then:

```
    $ rake db:migrate
    $ rake db:test:prepare
    $ rake jetty:clean
    $ rake curation_concerns:jetty:config
    $ rake jetty:start
    $ rails server
```

## Testing

```
    $ rake spec
```
