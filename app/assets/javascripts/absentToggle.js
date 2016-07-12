$('a[id^=btn]').click(
  function(){
    var id = this.id.split('-')[1];
    $('div .hidden-submit.'+ id).toggle();
  }
);
