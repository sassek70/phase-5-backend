# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    #change this to front end url for deployment
    origins "https://a-not-so-magical-gathering.onrender.com"

    resource "*",
      headers: :any,
      methods: [:get, :post, :patch, :delete, :options, :head]
  end

  allow do
    #change this to front end url for deployment
    origins "localhost:4000"

    resource "*",
      headers: :any,
      methods: [:get, :post, :patch, :delete, :options, :head]
  end
end
