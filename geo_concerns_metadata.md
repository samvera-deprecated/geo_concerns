Property | Predicate | Constraint | Applies to | Source
----- | ----- | ----- | ----- | ----- 
:title | ::RDF::Vocab::DC.title | Required | Layer | curation_concerns/required_metadata.rb
:date_uploaded | ::RDF::Vocab::DC.dateSubmitted | Required | Layer | curation_concerns/required_metadata.rb
:date_modified | ::RDF::Vocab::DC.modified | Required | Layer | curation_concerns/required_metadata.rb
:coverage | ::RDF::Vocab::DC11.coverage | Required | Layer | geo_concerns/basic_geo_metadata_required.rb
:provenance | ::RDF::Vocab::DC.provenance | Required | Layer | geo_concerns/basic_geo_metadata_required.rb
:contributor | ::RDF::Vocab::DC11.contributor | Optional | Layer | curation_concerns/basic_metadata.rb
:creator | ::RDF::Vocab::DC11.creator | Optional | Layer | curation_concerns/basic_metadata.rb
:date_created | ::RDF::Vocab::DC.created | Optional | Layer | curation_concerns/basic_metadata.rb
:description | ::RDF::Vocab::DC11.description | Optional | Layer | curation_concerns/basic_metadata.rb
:identifier | ::RDF::Vocab::DC.identifier | Optional | Layer | curation_concerns/basic_metadata.rb
:language | ::RDF::Vocab::DC11.language | Optional | Layer | curation_concerns/basic_metadata.rb
:part_of | ::RDF::Vocab::DC.isPartOf | Optional | Layer | curation_concerns/basic_metadata.rb
:publisher | ::RDF::Vocab::DC11.publisher | Optional | Layer | curation_concerns/basic_metadata.rb
:resource_type | ::RDF::Vocab::DC.type | Optional | Layer | curation_concerns/basic_metadata.rb
:rights | ::RDF::Vocab::DC.rights | Optional | Layer | curation_concerns/basic_metadata.rb
:source | ::RDF::Vocab::DC.source | Optional | Layer | curation_concerns/basic_metadata.rb
:subject | ::RDF::Vocab::DC11.subject | Optional | Layer | curation_concerns/basic_metadata.rb
:tag * | ::RDF::Vocab::DC11.relation | Optional | Layer | curation_concerns/basic_metadata.rb
:spatial | ::RDF::Vocab::DC.spatial | Optional | Layer | geo_concerns/basic_geo_metadata_optional.rb
:temporal | ::RDF::Vocab::DC.temporal | Optional | Layer | geo_concerns/basic_geo_metadata_optional.rb
:issued | ::RDF::Vocab::DC.issued | Optional | Layer | geo_concerns/basic_geo_metadata_optional.rb
:geo_mime_type | ::RDF::Vocab::EBUCore.hasMimeType | Required | FileSet | file_set_metadata_required.rb
 |  |  |  | 
* note: this property has been renamed `:keyword` in curation_concerns/basic_metadata |  |  |  | 
