
function copyCitation(citation) {
  /* Select the span text, copy it, then clear the selection */
  var range, selection;
  if (window.getSelection && document.createRange) {
    selection = window.getSelection();
    range = document.createRange();
    range.selectNodeContents(citation);
    selection.removeAllRanges();
    selection.addRange(range);
    document.execCommand("copy");
    selection.removeAllRanges();
  } else if (document.selection && document.body.createTextRange) {
    range = document.body.createTextRange();
    range.moveToElementText(citation);
    range.select();
    document.execCommand("copy");
    document.selection.empty();
  }
}

$( document ).ready(function() {

  // Add tooltips to the buttons, and click event listeners
  $('#citeWork').find('.btn').each(function(){
    var $this = $(this);

    $this.tooltip({
      title: 'Click to copy citation',
      placement: 'top',
      trigger: 'hover'
    });

    $this.click(function(e){
      e.stopPropagation();
      e.preventDefault();
      $this.tooltip('destroy');
      var citation = $this.siblings('span').get(0);
      copyCitation(citation);
      // tooltip.destroy is asyncronous, allow time to complete before creating new tooltip
      setTimeout(function () {
        $this.tooltip({title: "Copied!", placement: 'top', trigger: 'hover'});
        $this.tooltip('show');
      }, 200);
    }).mouseleave(function(){
      $this.tooltip('destroy');
      setTimeout(function () {
        $this.tooltip({title: 'Click to copy citation', placement: 'top', trigger: 'hover'});
      }, 200);
    });
  });

}); 
