$(document).ready(function(){
  $('li.timestamp').click(function(){
    $(this).next().slideToggle();
  });
});