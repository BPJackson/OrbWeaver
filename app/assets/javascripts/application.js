//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require spin
//= require_tree .

// scroll effect on arrows
$(function(){
  console.log("hello");
  $(".goto-next").on("click", function() {
    var sectionId = $(this).data('next');
    $('html, body').animate({scrollTop: $(sectionId).offset().top }, 2000);
  });
  // generate playlist load animation
  $("#generate-btn").on('click', function(e){
    var opts = {
      lines: 14, // The number of lines to draw
      length: 20, // The length of each line
      width: 10, // The line thickness
      radius: 30, // The radius of the inner circle
      corners: 1, // Corner roundness (0..1)
      rotate: 0, // The rotation offset
      direction: 1, // 1: clockwise, -1: counterclockwise
      color: '#000', // #rgb or #rrggbb or array of colors
      speed: 1, // Rounds per second
      trail: 60, // Afterglow percentage
      shadow: false, // Whether to render a shadow
      hwaccel: false, // Whether to use hardware acceleration
      className: 'spinner', // The CSS class to assign to the spinner
      zIndex: 2e9, // The z-index (defaults to 2000000000)
      top: '71%', // Top position relative to parent
      left: '50%' // Left position relative to parent
    };
    var target = document.getElementById('spinnerjs');
    var spinner = new Spinner(opts).spin(target);
  });
  // update city load animation
  $("#update-city-btn").on('click', function(e){
    var opts = {
      lines: 14, // The number of lines to draw
      length: 20, // The length of each line
      width: 10, // The line thickness
      radius: 30, // The radius of the inner circle
      corners: 1, // Corner roundness (0..1)
      rotate: 0, // The rotation offset
      direction: 1, // 1: clockwise, -1: counterclockwise
      color: '#000', // #rgb or #rrggbb or array of colors
      speed: 1, // Rounds per second
      trail: 60, // Afterglow percentage
      shadow: false, // Whether to render a shadow
      hwaccel: false, // Whether to use hardware acceleration
      className: 'spinner', // The CSS class to assign to the spinner
      zIndex: 2e9, // The z-index (defaults to 2000000000)
      top: '50%', // Top position relative to parent
      left: '50%' // Left position relative to parent
    };
    var target = document.getElementById('spinnerjs');
    var spinner = new Spinner(opts).spin(target);
  });

})
