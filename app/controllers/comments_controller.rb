# frozen_string_literal: true

class CommentsController < ApplicationController
  def new; end

  def create
    if params[:report_id].present?
      @report = Report.find(params[:report_id])
      @comment = @report.comments.build(comment_params)
      redirect_path = report_url(@report)
    else
      @book = Book.find(params[:book_id])
      @comment = @book.comments.build(comment_params)
      redirect_path = book_url(@book)
    end

    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        format.html { redirect_to redirect_path, notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { redirect_to redirect_path, status: :unprocessable_entity, notice: @comment.errors.full_messages }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if params[:report_id].present?
      @report = Report.find(params[:report_id])
      redirect_path = report_url(@report)
      redirect_controller = 'reports'
    else
      @book = Book.find(params[:book_id])
      redirect_path = book_url(@book)
      redirect_controller = 'books'
    end

    @comment = Comment.find(params[:id])

    if @comment.user_id != current_user.id
      redirect_to controller: redirect_controller, action: 'show'
      return
    end

    @comment.destroy

    respond_to do |format|
      format.html { redirect_to redirect_path, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human) }
      format.json { head :no_content }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
