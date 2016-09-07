/**
* Provides basic functionality to add and remove member works.
* Adapted from the table.es6 module in https://github.com/projecthydra/sufia
*/
export default class RelatedWorks {
  constructor(element) {
    this.element = $(element);
    this.table = this.element.find('table');
    this.query_url = this.table.data('query-url');
    if (!this.query_url) {
      return;
    }
    this.members = this.table.data('members');
    this.works = this.table.find('tr');
    this.workIds = Array.from(this.works.map((i) => this.works.eq(i).data('work-id')));
    this.paramKey = this.table.data('param-key');
    this.bindButtons();
  }

  /**
  * Bind buttons to member works table.
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
    $this.element.find('.btn-add-row').click(() => {
      const $row = $this.element.find('.member-actions');
      const memberId = $this.element.find('input').val();
      const updatedMembers = $this.members.slice();
      if (memberId === '') {
        $this.setWarningMessage($row, 'ID cannot be empty.');
      } else if ($.inArray(memberId, $this.workIds) > -1) {
        $this.setWarningMessage($row, 'Work is already related.');
      } else {
        updatedMembers.push(memberId);
        $this.hideWarningMessage($row);
        $this.callAjax({
          row: $row,
          members: updatedMembers,
          member: memberId,
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
    $this.element.find('.btn-remove-row').click(function removeButton() {
      const $row = $(this).parents('tr:first');
      const memberId = $row.data('work-id');
      const index = $this.members.indexOf(memberId);
      const updatedMembers = $this.members.slice();
      updatedMembers.splice(index, 1);
      $this.callAjax({
        row: $row,
        members: updatedMembers,
        member: memberId,
        data: $this.buildFormData(updatedMembers),
        url: $this.query_url,
        on_error: $this.handleError,
        on_success: $this.handleRemoveRowSuccess,
      });
    });
  }

  /**
  * Builds form data strings.
  * @param {Array} array of ids
  */
  buildFormData(ids) {
    return ids;
  }

  /**
   * Set the warning message related to the appropriate row in the table
   * @param {jQuery} row the row containing the warning message to display
   * @param {String} message the warning message text to set
   */
  setWarningMessage(row, message) {
    const $this = this;
    $this.element.find('.message.has-warning').text(message).removeClass('hidden');
  }

  /**
   * Hide the warning message on the appropriate row
   * @param {jQuery} row the row containing the warning message to hide
   */
  hideWarningMessage(row) {
    const $this = this;
    $this.element.find('.message.has-warning').addClass('hidden');
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
  * Reloads the child works tables after ajax call for member work.
  * Rebinds the add and remove buttons to the updated table.
  */
  reloadTable() {
    const $this = this;
    $this.element.load(`${$this.query_url} div#${this.element[0].id}`, () => {
      $this.bindButtons();
    });
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
   * Update list of child work ids and list of members. Reload the
   * table from the server.
   * @param {Object} args the table, row, input, url, and callbacks
   */
  handleRemoveRowSuccess(args) {
    // update list of child member works
    const index = this.workIds.indexOf(args.member);
    this.workIds.splice(index, 1);

    // update master list of member works
    this.members = args.members;

    this.reloadTable();
  }

  /**
   * Update list of child work ids and list of members.
   * Clear the add row input and reload the table from the server.
   * @param {Object} args the table, row, input, url, and callbacks
   */
  handleAddRowSuccess(args) {
    // update list of child member works
    this.workIds.push(args.member);

    // update master list of member works
    this.members = args.members;

    // empty the "add" row input value
    this.element.find('input').val('');

    this.reloadTable();
  }
}
