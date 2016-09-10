$('a[id^=btn]').click(
  function(event){
    event.preventDefault();
    var id = this.id.split('-')[1];
    $('div .hidden-submit.'+ id).toggle();
  }
);
