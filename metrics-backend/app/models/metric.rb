# frozen_string_literal: true

# Metric model
class Metric < ApplicationRecord
  validates :timestamp, :name, :value, :metric_type, :unit, presence: true
end
