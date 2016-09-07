//= require geo_concerns/geo_concerns_boot
//= require geo_concerns/relationships

Blacklight.onLoad(function() {
  Initializer = require('geo_concerns/geo_concerns_boot')
  window.gc = new Initializer()
})
