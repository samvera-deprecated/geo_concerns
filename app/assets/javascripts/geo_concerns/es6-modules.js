//= require geo_concerns/relationships
//= require geo_concerns/metadata_files
//= require geo_concerns/geo_concerns_boot

Blacklight.onLoad(function() {
  Initializer = require('geo_concerns/geo_concerns_boot')
  window.gc = new Initializer()
})
