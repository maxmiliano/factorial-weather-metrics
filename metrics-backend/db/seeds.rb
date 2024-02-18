# frozen_string_literal: true

require 'csv'

puts "Seeding Metrics"
CSV.read(Rails.root.join('db', 'seeds', 'metrics.csv'), headers: true).each do |row|
  metric = Metric.new(row.to_h)
  metric.save!

rescue ActiveRecord::RecordInvalid => e
  puts "Error creating metric: #{e.message}"
end
