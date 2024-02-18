# frozen_string_literal: true

# Controller for the Metric
class MetricsController < ApplicationController
  before_action :set_metric, only: %i[destroy show update]

  # GET /metrics
  def index
    render json: Metric.all, status: :ok
  end

  # GET /metrics/:id
  def show
    render json: @metric, status: :ok
  end

  # POST /metrics
  def create
    @metric = Metric.new(metric_params)
    @metric.save!
    render json: @metric, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # PUT /metrics/:id
  def update
    @metric.update!(metric_params)
    render json: @metric, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # DELETE /metrics/:id
  def destroy
    @metric.destroy!
    render status: :no_content
  end

  # GET /metrics/averages?interval=
  def averages
  interval = params[:interval] || 'minute' # Default to minute
  metrics = Metric.average_by_interval(interval)
  render json: metrics, status: :ok
  end

  private

  def set_metric
    @metric = Metric.find_by!(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Metric not found' }, status: :not_found
  end

  def metric_params
    params.require(:metric).permit(:timestamp, :name, :value, :metric_type, :unit)
  end
end
