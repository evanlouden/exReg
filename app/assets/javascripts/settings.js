$('a[id^=add]').click(
  function(){
    var id = this.id.split('-')[1]
    $('.hidden-submit.' + id).toggle();
  }
);
