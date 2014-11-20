// うっとうしいアニメーション
$(function() {
  $('input').each(function() {
    $(this).on('focus', function() {
      $(this).animate({
        opacity: 0
      }, 300);
    });
    $(this).on('blur', function() {
      $(this).animate({
        opacity: 1
      });
    })
  });
});
