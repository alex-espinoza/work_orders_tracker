$(function() {
	$(".thumbnail-size-image").on("mouseover", function(e) {
  $(".full-size-image").show();
});

	$(".thumbnail-size-image").on("mouseout", function(e) {
  $(".full-size-image").hide();
});
});
