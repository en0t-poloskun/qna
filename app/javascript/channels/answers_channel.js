import consumer from "./consumer"
import processVoting from 'packs/rating'

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(answer) {
    if (gon.current_user_id == answer.author_id) { return; }

    const answersList = $('.answers');
    const answer_template = $(answer.template);

    if (gon.current_user_id != answer.question_author_id) {
      $('.mark_best_link', answer_template).remove();
    }

    if (!gon.current_user_id) {
      $('.vote-actions', answer_template).remove();
    }

    answersList.append(answer_template);
    $('.vote-actions').on('ajax:success', processVoting)
  }
});
