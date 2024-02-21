# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Metrics' do
  describe 'GET /index' do
    before do
      create(:metric, name: 'Temperature', value: 26.2, metric_type: 'Temperature', unit: '°C')
      create(:metric, name: 'Humidity', value: 80.0, metric_type: 'Humidity', unit: '%')
    end

    it 'returns http ok' do
      get '/metrics'
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      expect(response.body).to include('Temperature')
      expect(response.body).to include('Humidity')
    end
  end

  describe 'POST /create' do
    let(:perform_request) { post '/metrics', params: { metric: metric_attributes } }

    context 'with valid parameters' do
      let(:metric_attributes) do
        {
          timestamp: Time.current,
          name: 'Temperature',
          value: 26.2,
          metric_type: 'Temperature',
          unit: '°C'
        }
      end

      it 'creates a new Metric' do
        expect { perform_request }.to change(Metric, :count).by(1)
      end

      it 'returns the created Metric' do
        perform_request
        parsed_response = response.parsed_body
        expect(parsed_response).to include(
          'name' => metric_attributes[:name],
          'value' => metric_attributes[:value].to_s,
          'metric_type' => metric_attributes[:metric_type],
          'unit' => metric_attributes[:unit]
        )
        expect(parsed_response['id']).to be_present
        expect(Time.zone.parse(parsed_response['timestamp'])).to eq(Time.zone.parse(metric_attributes[:timestamp].to_s))
      end

      it 'returns a 201 status code' do
        perform_request
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid parameters' do
      let(:metric_attributes) do
        {
          timestamp: Time.current,
          name: 'Temperature',
          value: 26.2,
          metric_type: 'Temperature'
        }
      end

      it 'returns a 422 status code' do
        perform_request
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        json_response = response.parsed_body
        expect(json_response['errors']).to include(
          { 'unit' => ["can't be blank"] }
        )
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:metric) { create(:metric) }
    let(:perform_request) { delete "/metrics/#{metric_id}" }

    context 'when the Metric exists' do
      let(:metric_id) { metric.id }

      it 'deletes a Metric' do
        perform_request
        expect(response).to have_http_status(:no_content)
        expect { metric.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the Metric does not exist' do
      let(:metric_id) { 999 }

      it 'returns a 404 status code' do
        perform_request
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /show' do
    let(:metric) { create(:metric) }

    let(:perform_request) { get "/metrics/#{metric_id}" }

    context 'when the Metric exists' do
      let(:metric_id) { metric.id }

      it 'returns a Metric' do
        perform_request
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        parsed_response = response.parsed_body
        expect(parsed_response).to include(
          'name' => metric.name,
          'value' => metric.value.to_s,
          'metric_type' => metric.metric_type,
          'unit' => metric.unit
        )
        expect(parsed_response['id']).to eq(metric.id)
        expect(Time.zone.parse(parsed_response['timestamp'])).to eq(metric.timestamp)
      end
    end

    context 'when the Metric does not exist' do
      let(:metric_id) { 999 }

      it 'returns a 404 status code' do
        perform_request
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT /update' do
    let(:perform_request) { put "/metrics/#{metric_id}", params: { metric: update_attributes } }

    context 'when the Metric exists' do
      let(:metric) { create(:metric) }

      context 'with valid parameters' do
        let(:metric_id) { metric.id }
        let(:update_attributes) do
          { name: 'Temperature', value: 26.2, metric_type: 'Temperature', unit: '°C' }
        end

        it 'updates the Metric' do
          perform_request
          metric.reload
          expect(metric.name).to eq(update_attributes[:name])
          expect(metric.value).to eq(update_attributes[:value])
          expect(metric.metric_type).to eq(update_attributes[:metric_type])
          expect(metric.unit).to eq(update_attributes[:unit])
        end

        it 'returns a 200 status code' do
          perform_request
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to include('application/json')
        end

        it 'returns the updated Metric' do
          perform_request
          parsed_response = response.parsed_body
          expect(parsed_response).to include(
            'name' => update_attributes[:name],
            'value' => update_attributes[:value].to_s,
            'metric_type' => update_attributes[:metric_type],
            'unit' => update_attributes[:unit]
          )
          expect(parsed_response['id']).to eq(metric.id)
          expect(Time.zone.parse(parsed_response['timestamp'])).to eq(metric.timestamp)
        end
      end

      context 'with invalid parameters' do
        let(:metric_id) { metric.id }

        context 'with nil parameters' do
          let(:update_attributes) { { name: nil, value: nil, metric_type: nil, unit: nil } }

          it 'returns a 422 status code' do
            perform_request
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to include('application/json')
          end

          it 'returns the error message' do
            perform_request
            %w[name value metric_type unit].each do |attribute|
              json_response = response.parsed_body
              expect(json_response['errors']).to include(
                { attribute => ["can't be blank"] }
              )
            end
          end
        end

        context 'with empty parameters' do
          let(:update_attributes) { { name: '', value: '', metric_type: '', unit: '' } }

          it 'returns a 422 status code' do
            perform_request
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to include('application/json')
          end

          it 'returns the error message' do
            perform_request
            %w[name value metric_type unit].each do |attribute|
              json_response = response.parsed_body
              expect(json_response['errors']).to include(
                { attribute => ["can't be blank"] }
              )
            end
          end
        end
      end
    end
  end
end
