$("img").lazyload({effect:"fadeIn"})

$.ajax({
  url: '/run_caching',
  method: 'get',
  async: true,
  success: function(){}
});
