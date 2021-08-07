$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
      e.preventDefault();
      $(this).hide();
      const answerId = $(this).data('answerId');
      console.log(answerId);
      $('form#edit-answer-' + answerId).removeClass('d-none');
  })
});
