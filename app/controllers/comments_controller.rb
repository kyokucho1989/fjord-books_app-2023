# frozen_string_literal: true

class CommentsController < ApplicationController
  def new; end

  def create
    if params[:report_id].present?
      @report = Report.find(params[:report_id])
      @comment = @report.comments.build(comment_params)
    else
      @book = Book.find(params[:book_id])
      @comment = @book.comments.build(comment_params)
    end
    @comment.user_id = current_user.id
    @comment.save

    if params[:report_id].present?
      redirect_to report_url(@report)
    else
      redirect_to book_url(@book)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
