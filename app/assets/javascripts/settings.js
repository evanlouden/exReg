$('a[id^=add]').click(
  function(event){
    event.preventDefault();
    var id = this.id.split('-')[1];
    $('.hidden-submit.' + id).toggle();
    $(this).parent().parent().find('form').enableClientSideValidations();
    // $("#new_instrument").enableClientSideValidations();
  }
);

// window.ClientSideValidations.callbacks.element.fail = function(element, message, callback) {
//   $('.submit').prop("disabled",true);
//   callback();
// };
//
// window.ClientSideValidations.callbacks.element.pass = function(element, callback) {
//   $('.submit').prop("disabled",false);
//   callback();
// };
