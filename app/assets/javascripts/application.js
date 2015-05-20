//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

// scroll effect on arrows
$(function(){
  console.log("hello");
  $(".goto-next").on("click", function() {
    var sectionId = $(this).data('next');
    $('html, body').animate({scrollTop: $(sectionId).offset().top }, 2000);
  });
})
