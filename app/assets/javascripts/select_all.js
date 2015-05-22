$(function() {
  $("#selectall").click(function(){
    var checked = this.checked;
    $('.selectallable').each(function(){
      this.checked = checked;
    });
  });
});
