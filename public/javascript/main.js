$(document).ready(function(){
  $('pre').click(function(){
    return false;
  });
  
  $('.processes ul').click(function(){
    $('.processes ul li.procs').slideUp();
    if ($(this).find('li.procs').is(':hidden')) {
      $(this).find('li.procs').slideDown();
    }
  });
  
  $('#max_memused_form').submit(function(){
    $.ajax({
      type: 'PUT',
      data: 'memory_threshold='+ $("input#memory_threshold").val(),
      url: '/max_memused',
      success: function(data){
        $('#memory_threshold_result').addClass('success').html(data);
      },
      error: function(data){
        $('#memory_threshold_result').addClass('failed').html(data);
      },
      complete: function(){
        $('#memory_threshold_result').fadeOut(3000, function(){
          $(this).html('').removeClass('success failed').show();
        });
      }
    });
    return false;
  });
  
  $('#max_memused_form input').click(function(){
    $(this).select();
  });
});