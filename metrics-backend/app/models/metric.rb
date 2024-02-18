# frozen_string_literal: true

# Metric model
class Metric < ApplicationRecord
  validates :timestamp, :name, :value, :metric_type, :unit, presence: true

  scope :average_by_interval, ->(interval = 'minute') {
    interval_group = sanitize_sql_for_conditions(["DATE_TRUNC(?, timestamp)", interval])
    select("#{interval_group} as interval_group, name, AVG(value) as average_value, metric_type, unit, COUNT(*) as count")
      .group("#{interval_group}, name, metric_type, unit")
      .order("interval_group desc, name ASC, metric_type ASC, unit ASC")
  }

  private

  def self.sanitize_interval(interval)
    %w[minute hour day].include?(interval) ? interval : 'minute' # Default to minute
  end
end
