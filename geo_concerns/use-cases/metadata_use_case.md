# Use Cases for Geospatial Metadata and Data Models
_Please note that these were drafted with descriptive metadata being the primary scope_

Sponsors: @jrgriffiniii

```
Given a georeferenced image
As a repository comprised in part of georeferenced images and vector feature sets
I want to upload the georeferenced image as a Raster resource
And I want to derive one or many images from the georeferenced image
So that I can view resized, lower resolution images for the Raster resource
```

```
Given a georeferenced image
As a repository comprised in part of georeferenced images and vector feature sets
I want a repository administrator to upload the georeferenced image as a Raster resource
So that only certain user groups can access the georeferenced image
```

```
Given a bounding box for a set of georeferenced images
As a repository comprised in part of georeferenced images and vector feature sets
I want a repository administrator to set the access control policies for Raster resources
So that only certain user groups can discover the georeferenced images
```

```
Given a georeferenced image
As a repository comprised in part of georeferenced images and vector feature sets
I want to upload the georeferenced image as a Raster resource
And I want to upload vector feature sets extracted from the georeferenced image
So that I can access KML Documents, GeoJSON Objects, or Shapefiles for the Raster resource
```

```
Given an image which has not been georeferenced
As a repository comprised in part of images, georeferenced images, and vector feature sets
I want to relate the images to a Raster resource
```

```
Given a bounding box for a set of georeferenced images
As a repository comprised in part of georeferenced images and vector feature sets
I want to discover all Raster resources referenced to a point or area within this bounding box
```

The following are examples of georeferenced images which fall within the scope of these use cases:

## A Scanned Map

Characteristics:

* Descriptive MD
* Rights MD
* A georeferenced image in the TIFF
