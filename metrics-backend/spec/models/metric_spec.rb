# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Metric do
  context 'with valid attributes' do
    let(:metric) { build(:metric) }

    it 'is valid' do
      expect(metric).to be_valid
    end

    it 'persists' do
      expect { metric.save! }.to change(described_class, :count).by(1)
    end
  end

  describe '.average_by_interval' do

    let(:time) { Time.new(2024, 1, 1, 12, 0, 0) } # 2024-01-01 12:00:00

    before do
      create(:metric, name: 'Paris', value: 26.2, metric_type: 'Temperature', unit: '°C', timestamp: time)
      create(:metric, name: 'Paris', value: 27.2, metric_type: 'Temperature', unit: '°C', timestamp: time + 15.seconds)
      create(:metric, name: 'Paris', value: 28.5, metric_type: 'Temperature', unit: '°C', timestamp: time + 30.minutes)
      create(:metric, name: 'Paris', value: 29.2, metric_type: 'Temperature', unit: '°C', timestamp: time + 2.hours)
      create(:metric, name: 'Paris', value: 30.2, metric_type: 'Temperature', unit: '°C', timestamp: time + 1.day)
    end

    context 'with minute interval' do
      let(:interval) { 'minute' }
      let(:expected_result) { 26.7 } # average of 26.2 and 27.2
      it 'returns the average value by minute' do
        average = Metric.average_by_interval('minute')
        result = average.find { |a| a.interval_group == time.strftime('%Y-%m-%d %H:%M:00') }

        expect(result.interval_group).to eq(time.strftime('%Y-%m-%d %H:%M:00'))
        expect(result.average_value.to_f).to eq(expected_result)
        expect(result.count).to eq(2)
      end
    end

    context 'with hour interval' do
      let(:interval) { 'hour' }
      let(:expected_result) { 27.3 } # average of 26.2, 27.2, 28.5
      it 'returns the average value by hour' do
        average = Metric.average_by_interval('hour')
        result = average.find { |a| a.interval_group == time.strftime('%Y-%m-%d %H:00:00') }

        expect(result.interval_group).to eq(time.strftime('%Y-%m-%d %H:00:00'))
        expect(result.average_value.to_f).to eq(expected_result)
      end
    end

    context 'with day interval' do
      let(:interval) { 'day' }
      let(:expected_result) { 27.775 } # average of 26.2, 27.2, 28.5, 29.2
      it 'returns the average value by day' do
        average = Metric.average_by_interval('day')
        result = average.find { |a| a.interval_group == time.strftime('%Y-%m-%d 00:00:00') }
        expect(result.interval_group).to eq(time.strftime('%Y-%m-%d 00:00:00'))
        expect(result.average_value.to_f).to eq(expected_result)
      end
    end
  end
end
