$(document).on('turbolinks:load', function() {

    $("button.facets-toggle").click(function() {
        $(".facets-toggle span.text").text(function(i, text) {
            return text === "Show Filters" ? "Hide Filters" : "Show Filters";
        });
        $(".facets-toggle span.glyphicon").toggleClass("glyphicon-chevron-down glyphicon-chevron-up");
    });

    // This corrects some urls for the facet panel displayed
    // on collection pages


    $('#facets a.facet_select').each(function() {
        url = $(this).attr('href');
        queryParam = url.split('?')[1]
            // $(this).attr('href', url.replace(/\/collections\/[a-zA-Z_]+\//i, "/catalog/"))
    });

    $('#facets a.more_facets_link').each(function() {

        url = $(this).attr('href');
        if (url.includes("collections")) {
            urlParam = url.replace(/\/collections\/[a-zA-Z_]+\//i, "/catalog/")
            pArray = urlParam.split('?');
            locIndex = pArray.indexOf('locale=en');
            if (locIndex > -1) {
                pArray.splice(locIndex, 1);
            }
            finalUrl = pArray.join('?').concat('?', queryParam)
            $(this).attr('href', finalUrl)
        }
    });

});