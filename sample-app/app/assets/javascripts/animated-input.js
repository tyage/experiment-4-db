// うっとうしいアニメーション
$(function() {
  $('input').each(function() {
    var width = $(this).outerWidth();
    var height = $(this).outerHeight();
    $(this).on('focus', function() {
      $(this).animate({
        width: width * 1.5,
        height: height * 1.5
      });
    });
    $(this).on('blur', function() {
      $(this).animate({
        width: width,
        height: height
      });
    })
  });
});
