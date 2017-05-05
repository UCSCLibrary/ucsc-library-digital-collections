jQuery(document).ready(function() {

  jQuery( "#bmi-tabs" ).tabs()     

  jQuery("button.dropdown").click(function() {
    var id = jQuery(this).siblings("input.row-id").val()
    var rowInfoDiv = jQuery(this).parent().siblings(".row-info")
    if (rowInfoDiv.html())  {
      rowInfoDiv.html("")
    } else {
      jQuery.get(window.location.pathname + "/row_info?row_id=" + id,function(data) {
        rowInfoDiv.html(data)
      });
    }
  });
});  
