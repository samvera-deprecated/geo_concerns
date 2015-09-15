# Coding: utf-8
version = File.read(File.expand_path("../VERSION", __FILE__)).strip

Gem::Specification.new do |spec|
  spec.name          = "geo_concerns"
  spec.version       = version
  spec.authors       = ["Darren Hardy", "Eliot Jordan", "John Huck", "Eric James", "James Griffin"]
  spec.email         = [""]
  spec.summary       = %q{Rails application for developing Hydra Geo models. Built around Curation Concerns engine. }
  spec.description   = %q{Rails application for developing Hydra Geo models. Built around Curation Concerns engine. }
  spec.homepage      = ""
  spec.license       = "APACHE2"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = []
end
