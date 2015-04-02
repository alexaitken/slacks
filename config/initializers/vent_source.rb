Rails.application.config.to_prepare do

  VentSource.configure do |config|

    config.clear_handlers!
    config.define_handlers do |handlers|
      handlers << { aggregate_type: 'Person', consumer: 'Login' }
    end

  end
end
