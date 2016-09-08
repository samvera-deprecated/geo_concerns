import ChildWorks from 'geo_concerns/relationships/child_works'
import ParentWorks from 'geo_concerns/relationships/parent_works'
import MetadataFiles from 'geo_concerns/metadata_files'
export default class Initializer {
  constructor() {
    this.child_works = new ChildWorks('#child-works')
    this.parent_works = new ParentWorks('#parent-works')
    this.metadata_files = new MetadataFiles('#metadata-files')
  }
}
