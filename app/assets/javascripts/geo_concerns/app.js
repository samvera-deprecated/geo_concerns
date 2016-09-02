GeoConcerns = {
    initialize: function () {
        this.relationships_table();
    },

    relationships_table: function () {
        var rel = require('geo_concerns/relationships/table');
        $('table.relationships-ajax-enabled').each(function () {
            new rel.RelationshipsTable($(this));
        });
    },

};

Blacklight.onLoad(function () {
    GeoConcerns.initialize();
});
