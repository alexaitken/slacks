# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
Rails.application.eager_load!
ActionCable.server.config.disable_request_forgery_protection = true
run Rails.application
