# frozen_string_literal: true

# Metric model
class Metric < ApplicationRecord
  validates :timestamp, :name, :value, :metric_type, :unit, presence: true

  scope :average_by_interval, lambda { |interval = 'minute'|
    interval_group = sanitize_sql_for_conditions(['DATE_TRUNC(?, timestamp)', interval])
    select(
      "#{interval_group} as interval_group, name, AVG(value) as average_value, metric_type, unit, COUNT(*) as count"
    )
      .group(:name, interval_group, :metric_type, :unit)
      .order(name: :asc, interval_group: :desc, metric_type: :asc, unit: :asc)
  }

  def self.sanitize_interval(interval)
    %w[minute hour day].include?(interval) ? interval : 'minute'
  end
end
