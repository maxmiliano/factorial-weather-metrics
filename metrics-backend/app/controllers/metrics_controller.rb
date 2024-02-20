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
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  # POST /metrics
  def create
    @metric = Metric.new(metric_params)
    @metric.save!
    render json: @metric, status: :created
  rescue ActiveRecord::RecordInvalid => e
    errors = @metric.errors || [e.message]
    render json: { errors: }, status: :unprocessable_entity
  end

  # PUT /metrics/:id
  def update
    @metric.update!(metric_params)
    render json: @metric, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    errors = @metric.errors || [e.message]
    render json: { errors: }, status: :unprocessable_entity
  end

  # DELETE /metrics/:id
  def destroy
    @metric.destroy!
    render status: :no_content
  rescue ActiveRecord::RecordNotDestroyed
    render json: { error: 'Metric not destroyed' }, status: :internal_server_error
  end

  # GET /metrics/averages?interval=
  def averages
    interval = params[:interval] || 'minute' # Default to minute
    metrics = Metric.average_by_interval(interval)
    render json: metrics, status: :ok
  rescue StandardError => e
    render json: "Error: #{e.message}", status: :internal_server_error
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
