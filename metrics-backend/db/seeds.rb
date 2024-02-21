# frozen_string_literal: true

require 'csv'

Rails.logger.debug 'Seeding Metrics'
CSV.read(Rails.root.join('db/seeds/metrics.csv'), headers: true).each do |row|
  metric = Metric.new(row.to_h)
  metric.save!
rescue ActiveRecord::RecordInvalid => e
  Rails.logger.debug { "Error creating metric: #{e.message}" }
end
