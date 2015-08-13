# Geo Concerns

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

# Usage

## Generator

To generate a new CurationConcern type, use the `curation_concerns:work` rails generator.  Follow the Usage instructions provided on the command line when you run:

    rails generate curation_concerns:work

## Testing

```
    $ rake spec
```