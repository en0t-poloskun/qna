$(document).on('turbolinks:load', function(){

  $('.vote-links').on('ajax:success', function(e) {
    const rating = e.detail[0];
    const id = rating.votable_class + '_' + rating.votable_id
    $('#' + id + ' > b').replaceWith( '<b> Rating: ' + rating.value + '</b>' );
  })
});
