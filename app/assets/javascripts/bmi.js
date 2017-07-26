jQuery(document).ready(function() {

  jQuery('button.select-all').click(function() {
    jQuery(this).siblings('ul.rows').find('input').prop('checked',true)
  });
  jQuery('button.deselect-all').click(function() {
    jQuery(this).siblings('ul.rows').find('input').prop('checked',false)
  });

  jQuery('ul.actions button').click(function() {
    var action = jQuery(this).attr('id')
    var form = jQuery(this).closest('form')
    form.append('<input type="hidden" name="process-action" value="'+action+'"/>')
    form.submit()
  });

  jQuery("button#toggle-ingest-info").click(function(){
    jQuery("div#ingest-info").toggle();
  });

  jQuery( "#bmi-tabs" ).tabs()     

  jQuery("button.dropdown").click(function() {
//    var id = jQuery(this).siblings("input.row-id").val()
    var id = jQuery(this).attr("data-row-id")
    var rowInfoDiv = jQuery(this).parent().siblings(".row-info")
    if (rowInfoDiv.html())  {
      rowInfoDiv.html("")
    } else {
      jQuery.get("/admin/bmi_rows/" + id +"/row_info",function(data) {
        rowInfoDiv.html(data)
      });
    }
  });
});  
