$(document).on('turbolinks:load', function() {
	$("#view-all-collections").click(function() {
		$("#all-collections").toggle(1000);
		$(this).text(function(i, text){
			return text === "View all collections" ? "Hide all collections" : "View all collections";
		});
	});
});
