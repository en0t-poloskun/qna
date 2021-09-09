import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(comment) {
      if (gon.current_user_id == comment.author_id) { return; }

      const commentsList = $(`#comments_${comment.commentable_type}_${comment.commentable_id}`);
      commentsList.append(comment.template)
    }
  })
})
