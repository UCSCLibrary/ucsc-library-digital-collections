function fetchManifest(event) {
  url = document.domain + "/concern/works/" + event.data.work_id + "/manifest"
  $.ajax({url:url,
          datatype: "json", 
          success: showManifest})
}

function showManifest(manifest,status) {
  
}

function work_id_from_image_url(image_url) {
  image_url.split("iiif/2").pop().split("files").shift().replace("/","").replace("%2F","")
}

$("div.thumb").click({work_id: work_id_from_image_url(this.data("src"))},fetchManifest)
