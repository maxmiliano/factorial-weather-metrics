# frozen_string_literal: true

FactoryBot.define do
  factory :metric do
    timestamp { '2024-02-15 21:17:04' }
    name { 'Main room Temprature' }
    value { '25.7' }
    metric_type { 'Temperature' }
    unit { '°C' }
  end
end
