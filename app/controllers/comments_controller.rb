# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    set_commentable
    @comment = @commentable.comments.build(comment_params)
    @comment.author = current_user
    @comment.save
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
end
