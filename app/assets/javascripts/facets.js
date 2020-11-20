$(document).ready(function() {
	$("button.facets-toggle").click(function() {
		$(".facets-toggle span.text").text(function(i, text){
			return text === "Show Filters" ? "Hide Filters" : "Show Filters";
		});
		$(".facets-toggle span.glyphicon").toggleClass("glyphicon-chevron-down glyphicon-chevron-up");
	});
});
