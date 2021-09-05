$(document).on('turbolinks:load', function(){

  $('.vote-actions').on('ajax:success', function(e) {
    const rating = e.detail[0];
    const id = rating.votable_class + '_' + rating.votable_id;
    const revote_link = $('#' + id + ' > .vote-actions > .re-vote-link');
    const vote_links = $('#' + id + ' > .vote-actions > .vote-links');

    $('#' + id + ' > .rating > b').replaceWith( '<b> Rating: ' + rating.value + '</b>' );
  
    if (revote_link.hasClass('d-none')) {
      vote_links.addClass('d-none');
      revote_link.removeClass('d-none');
    }
    else {
      revote_link.addClass('d-none');
      vote_links.removeClass('d-none');
    }
  })
});
