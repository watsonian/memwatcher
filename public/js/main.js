$(document).ready(function(){
  $('ul').click(function(){
    $(this).find('li.procs').slideToggle();
  });
});