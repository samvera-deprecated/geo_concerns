import RelatedWorks from 'geo_concerns/relationships/related_works';

/**
* Provides functionality to add and remove parent works.
*/
export default class ParentWorks extends RelatedWorks {
  /**
  * Builds form data string for in_works_ids.
  * @param {Array} array of parent member ids
  */
  buildFormData(ids) {
    let data;
    if (ids.length === 0) {
      data = `${this.paramKey}[in_works_ids][]=`;
    } else {
      data = ids.map((id) => `${this.paramKey}[in_works_ids][]=${id}`).join('&');
    }
    return data;
  }
}
