$(function() {
  $(".js-store-trading-hours").each(function(index,value) {
    $("#store_id-"+index).change(function () {
      $("#store-"+index).submit();
    })
  })
})