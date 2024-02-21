# frozen_string_literal: true

# This configuration avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:4000' # For development. when going to production, change this to the frontend URL origin
    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head]
  end
end
