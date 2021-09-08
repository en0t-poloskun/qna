import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(question) {
    const questionsList = $('.questions')
    const question_template = $(question.template)

    if (gon.current_user_id != question.author_id) {
      $('.action_links', question_template).remove();
    }

    questionsList.append(question_template)
  }
});
