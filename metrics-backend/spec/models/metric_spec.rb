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
end
