// うざいアニメーション
$.fn.animatedList = function() {
  this.each(function() {
    var contents = $(this).find('.animated-list-content');
    contents.hide();
    contents.each(function(i) {
      var self = this;
      setTimeout(function() {
        $(self).fadeIn();
      }, 200 * i);
    });
  });
  return this;
};

$(function() {
  $('.animated-list').animatedList();
});
