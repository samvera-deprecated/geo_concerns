/**
* External metadata files table behavior.
*/
export default class MetadataFiles {
  constructor(element) {
    this.element = $(element);
    this.table = this.element.find('table');
    this.query_url = this.table.data('query-url');
    if (!this.query_url) {
      return;
    }
    this.paramKey = this.table.data('param-key');
    this.bindPopulateButton();
  }

  /**
  * Handle click events by the "Populate" buttons in the table, and calling the
  * server to handle the request
  */
  bindPopulateButton() {
    const $this = this;
    $this.element.find('.btn-populate').click(function populateButton() {
      const $row = $(this).parents('tr:first');
      const memberId = $row.data('member-id');
      $this.callAjax({
        row: $row,
        data: $this.buildFormData(memberId),
        url: $this.query_url,
        on_error: $this.handleError,
        on_success: $this.handlePopulateMetadataSuccess,
      });
    });
  }

 /**
  * Builds form data string for should_populate_metadata attribute.
  * @param {String} id of external metadata file
  */
  buildFormData(id) {
    let data;
    if (id == null) {
      data = `${this.paramKey}[should_populate_metadata]=`;
    } else {
      data = `${this.paramKey}[should_populate_metadata]=${id}`;
    }
    return data;
  }

  /**
  * Call the server, then call the appropriate callbacks to handle success and errors
  * @param {Object} args the table, row, input, url, and callbacks
  */
  callAjax(args) {
    const $this = this;
    $.ajax({
      type: 'patch',
      url: args.url,
      dataType: 'json',
      data: args.data,
    })
      .done(() => {
        args.on_success.call($this);
      })
      .fail((jqxhr) => {
        args.on_error.call($this, args, jqxhr);
      });
  }

  /**
  * Set the warning message related to the appropriate row in the table
  * @param {jQuery} row the row containing the warning message to display
  * @param {String} message the warning message text to set
  */
  setWarningMessage(row, message) {
    row.find('.message.has-warning').text(message).show().delay(5000)
       .fadeOut(1000);
  }

  /**
  * Set a warning message to alert the user on an error
  * @param {Object} args the table, row, input, url, and callbacks
  * @param {Object} jqxhr the jQuery XHR response object
  */
  handleError(args, jqxhr) {
    let message = jqxhr.statusText;
    if (jqxhr.responseJSON) {
      message = jqxhr.responseJSON.description;
    }
    this.setWarningMessage(args.row, message);
  }

  /**
  * Reload the page on success.
  */
  handlePopulateMetadataSuccess() {
    window.location.reload();
  }
}
