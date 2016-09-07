import RelatedWorks from 'geo_concerns/relationships/related_works';

/**
* Provides functionality to add and remove child works.
*/
export default class ChildWorks extends RelatedWorks {
  /**
  * Builds form data string for ordered_member_ids.
  * @param {Array} array of ordered member ids
  */
  buildFormData(ids) {
    let data;
    if (ids.length === 0) {
      data = `${this.paramKey}[ordered_member_ids][]=`;
    } else {
      data = ids.map((id) => `${this.paramKey}[ordered_member_ids][]=${id}`).join('&');
    }
    return data;
  }
}
