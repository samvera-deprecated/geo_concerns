/**
* Provides functionality to add and remove child works.
* Adapted from the table.es6 module in https://github.com/projecthydra/sufia
*/
export default class ChildWorks {
  constructor() {
    this.element = $('.child-works');
    this.query_url = this.element.data('query-url');
    if (!this.query_url) {
      return;
    }
    this.members = this.element.data('members');
    this.childWorkIds = Array.from($('.child-work').map((i) => $('.child-work').eq(i).data('child-work-id')));
    this.paramKey = this.element.data('param-key');
    this.bindButtons();
  }

  /**
  * Bind buttons to child works table.
  */
  bindButtons() {
    const $this = this;
    $this.bindAddButton();
    $this.bindRemoveButton();
  }

  /**
  * Handle click events by the "Add" button in the table, setting a warning
  * message if the input is empty or calling the server to handle the request
  */
  bindAddButton() {
    const $this = this;
    $('.btn-add-row').click(() => {
      const $row = $('.child-actions');
      const childWorkId = $('#work_child_members_ids').val();
      const updatedMembers = $this.members.slice();
      if (childWorkId === '') {
        $this.setWarningMessage($row, 'ID cannot be empty.');
      } else if ($.inArray(childWorkId, $this.childWorkIds) > -1) {
        $this.setWarningMessage($row, 'Work is already related.');
      } else {
        updatedMembers.push(childWorkId);
        $this.hideWarningMessage($row);
        $this.callAjax({
          row: $row,
          members: updatedMembers,
          child: childWorkId,
          url: $this.query_url,
          data: $this.buildFormData(updatedMembers),
          on_error: $this.handleError,
          on_success: $this.handleAddRowSuccess,
        });
      }
    });
  }

  /**
  * Handle click events by the "Remove" buttons in the table, and calling the
  * server to handle the request
  */
  bindRemoveButton() {
    const $this = this;
    $('.btn-remove-row').click(function removeButton() {
      const $row = $(this).parents('tr:first');
      const childWorkId = $row.data('child-work-id');
      const index = $this.members.indexOf(childWorkId);
      const updatedMembers = $this.members.slice();
      updatedMembers.splice(index, 1);
      $this.callAjax({
        row: $row,
        members: updatedMembers,
        child: childWorkId,
        data: $this.buildFormData(updatedMembers),
        url: $this.query_url,
        on_error: $this.handleError,
        on_success: $this.handleRemoveRowSuccess,
      });
    });
  }

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

  /**
   * Set the warning message related to the appropriate row in the table
   * @param {jQuery} row the row containing the warning message to display
   * @param {String} message the warning message text to set
   */
  setWarningMessage(row, message) {
    row.find('.message.has-warning').text(message).removeClass('hidden');
  }

  /**
   * Hide the warning message on the appropriate row
   * @param {jQuery} row the row containing the warning message to hide
   */
  hideWarningMessage(row) {
    row.find('.message').addClass('hidden');
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
        args.on_success.call($this, args);
      })
      .fail((jqxhr) => {
        args.on_error.call($this, args, jqxhr);
      });
  }

  /**
  * Reloads the child works tables after ajax call for parent work.
  * Rebinds the add and remove buttons to the updated table.
  */
  reloadTable() {
    const $this = this;
    $('#child-works').load(`${$this.query_url} div#child-works`, () => {
      $this.bindButtons();
    });
  }

  /**
  * Set a warning message to alert the user on an error
  * @param {jQuery} $this the ChildWorks class instance
  * @param {Object} args the table, row, input, url, and callbacks
  * @param {Object} jqxhr the jQuery XHR response object
  * @param {String} status the HTTP error status
  */
  handleError(args, jqxhr) {
    let message = jqxhr.statusText;
    if (jqxhr.responseJSON) {
      message = jqxhr.responseJSON.description;
    }
    this.setWarningMessage(args.row, message);
  }

  /**
   * Update list of child work ids and list of ordered members. Reload the
   * table from the server.
   * @param {jQuery} $this the ChildWorks class instance
   * @param {Object} args the table, row, input, url, and callbacks
   * @param {String} json the returned JSON string
   */
  handleRemoveRowSuccess(args) {
    // update list of child member works
    const index = this.childWorkIds.indexOf(args.child);
    this.childWorkIds.splice(index, 1);

    // update master list of member works
    this.members = args.members;

    this.reloadTable();
  }

  /**
   * Update list of child work ids and list of ordered members.
   * Clear the add row input and reload the table from the server.
   * @param {jQuery} $this the ChildWorks class instance
   * @param {Object} args the table, row, input, url, and callbacks
   * @param {String} json the returned JSON string
   */
  handleAddRowSuccess(args) {
    // update list of child member works
    this.childWorkIds.push(args.child);

    // update master list of member works
    this.members = args.members;

    // empty the "add" row input value
    $('#work_child_members_ids').val('');

    this.reloadTable();
  }
}
