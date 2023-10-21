# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]

  def index
    @reports = Report.includes(:user).order(:id).page(params[:page])
  end

  def show; end

  def edit; end

  def update; end

  def destroy; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params[:id])
  end
end
