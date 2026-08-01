# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]

  # POST commentable/:id/comments
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.commentable = params[:book_id].present? ? Book.find(params[:book_id]) : Report.find(params[:report_id])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.commentable, notice: I18n.t('controllers.common.notice_create', name: Comment.model_name.human) }
      else
        format.html { render plain: @comment.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE commentable/:id/comments/:comment_id
  def destroy
    @commentable = @comment.commentable
    @comment.destroy!

    respond_to do |format|
      format.html { redirect_to @commentable, notice: I18n.t('controllers.common.notice_destroy', name: Comment.model_name.human) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.expect(comment: %i[body user commentable])
  end
end
