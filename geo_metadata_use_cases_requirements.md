# Use Cases for Geospatial Metadata
_Please note that these were drafted with descriptive metadata being the primary scope_

## FGDC (Content Standard for Digital Geospatial Metadata)
  1. Users search by full-text using the "Abstract" or "Purpose" of a data set
  2. Users search by faceted date range searches using the Time\_Period\_Information of a data set
  3. Users can facet upon the "Spatial_Domain" spatial bounding box featured by a data set
  4. Users can facet upon one or many "Theme" authorities tagging a data set
  5. Users can facet upon one or many "Place" authorities tagging a data set
  4. Users can facet upon one or many "Stratum" authorities tagging a data set
  6. Users can facet upon one or many "Temporal" authorities tagging a data set
  7. Curators can specify a "Theme\_Keyword\_Thesaurus" resolving to a controlled vocabulary for Theme authorities
  8. Curators can specify a "Place\_Keyword\_Thesaurus" resolving to a controlled vocabulary for Place name authorities
  9. Curators can specify a "Stratum\_Keyword\_Thesaurus" resolving to a controlled vocabulary for Theme authorities
  10. Curators can specify a "Temporal\_Keyword\_Thesaurus" resolving to a controlled vocabulary for Place name authorities
  11. Users can resolve URI's for persons specified as Point\_of\_Contact values
  11. Users cannot discover or access data sets bearing certain Security_Classification values
  12. Users can resolve resources specified within Cross_Reference element values

## ISO 19139 (Implements ISO 19115)
  1. Users can resolve URI's for persons specified within gmd:contact/gmd:contactInfo/gmd:CI_Contact child elements
  2. Users can facet upon date ranges using values specified within the gmd:dateStamp child elements
  3. Users can facet upon date ranges using values specified within gmd:identificationInfo/gmd:MD\_DataIdentification/gmd:citation/gmd:CI\_Citation/gmd:date child elements
  4. Users can search by full-text using the values within gmd:identificationInfo/gmd:MD\_DataIdentification/gmd:citation/gmd:CI\_Citation/gmd:title child elements
  5. Users can facet upon ISBN's using the values within gmd:identificationInfo/gmd:MD\_DataIdentification/gmd:citation/gmd:CI\_Citation/gmd:identifier child elements'
  6. Users can facet upon the form of the data set using the values within gmd:identificationInfo/gmd:MD\_DataIdentification/gmd:citation/gmd:CI\_Citation/gmd:presentationForm child elements
  7. Users can search by full-text using the values within gmd:abstract child elements
  8. Users can facet upon subject authorities using the gmd:topicCategory/gmd:MD_TopicCategoryCode elements values
  9. Users can facet upon subject authorities using the gmd:descriptiveKeywords elements values
  10. Users can facet upon the spatial bounding box using the values within gmd:extent/gmd:EX_Extent/gmd:geographicElement child elements

# Functional Requirements for Geospatial Metadata

1. Where possible, file names and network addresses should be structured as valid URI's[1]
2. Persistent URI schemes implemented by the Fedora Commons should map the persistent URI for the data set to the appropriate geospatial metadata element (e. g. gmd:dataSetURI)

[1] https://www.fgdc.gov/standards/projects/FGDC-standards-projects/metadata/base-metadata/v2_0698.pdf
