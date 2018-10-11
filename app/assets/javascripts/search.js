document.addEventListener("turbolinks:load", function() {
  $input = $("#search");
  
  var options = {
    getValue: "name",

    url: function(phrase) {
      return "/users/search.json?q=" + phrase;
    },

    list: {
      onChooseEvent: function() {
        var url = $input.getSelectedItemData().url
        $input.val("")
        Turbolinks.visit(url)
      },
      match: {
        enabled: true
      }
    },
  };

  $input.easyAutocomplete(options);
});