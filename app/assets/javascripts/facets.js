$(document).on('turbolinks:load', function() {

    $("button.facets-toggle").click(function() {
	$(".facets-toggle span.text").text(function(i, text){
	    return text === "Show Filters" ? "Hide Filters" : "Show Filters";
	});
	$(".facets-toggle span.glyphicon").toggleClass("glyphicon-chevron-down glyphicon-chevron-up");
    });

    // This corrects some urls for the facet panel displayed
    // on collection pages
    $('#facets a.more_facets_link').each(function() {
        url = $(this).attr('href');
        $(this).attr('href', url.replace(/\/collections\/[a-zA-Z_]+\//i,"/catalog/"))
    });
    
});
