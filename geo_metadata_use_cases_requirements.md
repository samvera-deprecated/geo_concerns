# Use Cases for Geospatial Metadata and Data Models
_Please note that these were drafted with descriptive metadata being the primary scope_

## Geospatial Resource Metadata
### Descriptive Metadata (FGDC and ISO 19139 XML Documents)
  1. Users shall be able to discover georeferenced raster resources (Raster) by specifying a bounding box

### Technical Metadata
  1. Users shall be able to access geospatial EXIF metadata tags in relation to georeferenced resources
  2. Users shall be able to embed geospatial EXIF metadata tags for [one (or many)][1] georeferenced resources
    1. _e. g. A user shall be able to georectify or reproject the SRS any given raster resource_

### Access Metadata/[Web Access Control][2]
  1. Repository administrators shall be able to restrict users who can read from a raster resource
    1. Administrators shall also be able to restrict access to all or some descriptive metadata fields for a raster resource
      1. _e. g. Users can access the raster resource but not descriptive metadata until it has been published for release_
  2. Repository administrators shall be able to restrict users who can replace or update the bitstream of a raster resource
    1. Administrators shall also be able to restrict the writing of all or some descriptive metadata fields for a raster resource
      1. _e. g. Users can modify only the Abstract (but not the Security_Classification) FGDC field values for a raster resource_
  3. Repository administrators shall be able to grant users the ability to control ACL privileges for a raster resource (i. e. grant "administrative" privileges)

## Data Modeling
  1. Users shall be able to upload only one georeferenced image for Raster resources
  1. Users shall be able to generate one or many derivative images for Raster resources
    1. _e. g. Users can generate multiple PNG images from a GeoTIFF at various sizes and resolutions_
  1. Users shall be able to upload (extracted) vector feature sets for Raster resources
    1. Users shall be able to download vector feature sets in a number of formats for any given Raster resource
      1. _e. g. Users shall be able to download a Shapefile, KML Document, or GeoJSON Object for a vector feature set_
  1. Users shall be able to relate georeferenced resources to non-georeferenced resources
    1. _e. g. Users can link a georeferenced map to a scanned map_

[1]: This encompasses use cases addressed using the batch editing functionality offered by the hydra-collections Gem
[2]: This follows the proposed [WebAccessControl ontology](http://www.w3.org/wiki/WebAccessControl) implemented in the RDF
