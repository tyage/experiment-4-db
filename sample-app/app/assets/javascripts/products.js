$(function() {
  var productDetail = $('#product-detail').css({
    position: 'absolute'
  });
  var isLeft = false;
  var interval = 2 * 1000;
  var marquee = function() {
    productDetail.animate({
      left: (isLeft ? 0 : $(window).width() - productDetail.width())
    }, interval);
    isLeft = !isLeft;
  };
  window.setInterval(function() {
    marquee();
  }, interval);
  marquee();
});
