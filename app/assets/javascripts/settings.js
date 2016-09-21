$('a[id^=add]').click(
  function(event){
    event.preventDefault();
    var id = this.id.split('-')[1];
    $('.hidden-submit.' + id).toggle();
    $(this).parent().parent().find('form').enableClientSideValidations();
  }
);
