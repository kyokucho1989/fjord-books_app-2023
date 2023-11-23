# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save
      update_mention
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      update_mention
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  def update_mention
    mentioned_report_id = @report.id
    mention_ids = mentioning_reports
    create_mention_ids = mention_ids[:create_ids]
    delete_mention_ids = mention_ids[:delete_ids]
    create_mention_ids.each do |id|
      mention = Mention.new(mentioning_report_id: id, mentioned_report_id:)
      mention.save
    end

    mention = Mention.where(mentioning_report_id: delete_mention_ids, mentioned_report_id:)
    mention.delete_all if !mention.empty?
  end

  def mentioning_reports
    mentioning_reports = @report.content.scan(%r{localhost:3000/reports/(\d+)}).flatten
    mentioning_reports.uniq!
    mentioning_reports.map!(&:to_i)

    create_reports_ids = mentioning_reports - @report.mentioning_report_ids
    delete_reports_ids = @report.mentioning_report_ids - mentioning_reports
    { create_ids: create_reports_ids, delete_ids: delete_reports_ids }
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
