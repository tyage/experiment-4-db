$(function() {
  $('#header-nav a').on('mousemove', function(e) {
    $(this).css({
      position: 'relative'
    });
    var offset = $(this).offset();
    var width =  $(this).width();
    var height =  $(this).height();
    var move = 10;
    $(this).animate({
      left: (e.clientX < offset.left + width / 2 ? '+' : '-') + '=' + move,
      top: (e.clientY < offset.top + height / 2 ? '+' : '-') + '=' + move
    }, 0);
  });
});
