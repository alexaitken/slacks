# cable/config.ru

require ::File.expand_path('../../config/environment',  __FILE__)
Rails.application.eager_load!

ActionCable.server.config.allowed_request_origins = ["http://#{ENV['HOST']}"]
ActionCable.server.config.disable_request_forgery_protection = true
run ActionCable.server
