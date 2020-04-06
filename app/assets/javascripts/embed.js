// Updates the embed code box in response to user input
function updateEmbedCode(uri, w, h, script) {
  // Custom dimensions can't be blank
  if (w.length == 0) { w = 1; }
  if (h.length == 0) { h = 1; }
  var embedTemplate = `<div class="uv" data-uri="${uri}" style="width:${w}px; height:${h}px; background-color: #000"></div><script type="text/javascript" id="embedUV" src="${script}"></script><script type="text/javascript">/* wordpress fix */</script>`;
  document.getElementById("embedCode").value = embedTemplate;
}

$(document).ready(function() {
  // Set default size and initalize iframe dimensions
  $('#embedSize').val('small');
  var selected = $('#embedSize').find(':selected');
  var iframeWidth = selected.attr('data-width');
  var iframeHeight = selected.attr('data-height');

  // Set defaults for the custom dimensions
  $('#embedWidth').val(iframeWidth);
  $('#embedHeight').val(iframeHeight);

  // Create work URI, script URI, and initalize the embed code
  var dataUri = window.location.pathname + '/manifest?locale=en';
  var scriptSrc = window.location.protocol + '//' + window.location.hostname + '/universalviewer/dist/uv-2.0.1/lib/embed.js';
  updateEmbedCode(dataUri, iframeWidth, iframeHeight, scriptSrc);

  // Act on changes to the size dropdown
  $('#embedSize').on('change', function() {
    if (this.value == 'custom') {
      $('#embedWidth, #embedX, #embedHeight').show();
      iframeWidth = $('#embedWidth').val();
      iframeHeight = $('#embedHeight').val();
      updateEmbedCode(dataUri, iframeWidth, iframeHeight, scriptSrc);
    }
    else {
      $('#embedWidth, #embedX, #embedHeight').hide();
      selected = $(this).find(':selected');
      iframeWidth = selected.attr('data-width');
      iframeHeight = selected.attr('data-height');
      updateEmbedCode(dataUri, iframeWidth, iframeHeight, scriptSrc);
    }
  });

  // Enforce numbers only on custom dimension fields and update after change
  $('#embedWidth, #embedHeight').keyup(function () {
    this.value = this.value.replace(/[^0-9\.]/g,'');
    iframeWidth = $('#embedWidth').val();
    iframeHeight = $('#embedHeight').val();
    updateEmbedCode(dataUri, iframeWidth, iframeHeight, scriptSrc);
  });

  // Select all text when the user clicks in the embed code input box
  $('#embedCode').click(function() {
    $(this).select();
  });

});
