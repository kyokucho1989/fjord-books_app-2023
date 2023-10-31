# frozen_string_literal: true

class CommentsController < ApplicationController
  def new; end

  def create
    @report = Report.find(params[:report_id])
    @comment = @report.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to report_url(@report)
    else
      render :new
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
