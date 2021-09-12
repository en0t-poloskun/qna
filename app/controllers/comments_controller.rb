# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    set_commentable
    @comment = @commentable.comments.build(comment_params)
    @comment.author = current_user
    @comment.save
    publish_comment
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    @commentable = commentable_name.classify.constantize.find(commentable_id)
  end

  def commentable_id
    params["#{commentable_name.classify.downcase}_id"]
  end

  def commentable_name
    params[:commentable]
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast "question_#{@comment.question.id}_comments",
                                 { author_id: @comment.author.id,
                                   commentable_type: @comment.commentable_type.downcase,
                                   commentable_id: @comment.commentable.id,
                                   template: comment_template }
  end

  def comment_template
    ApplicationController.render(partial: 'comments/comment', locals: { comment: @comment })
  end
end
