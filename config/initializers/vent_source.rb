Rails.application.config.to_prepare do

  VentSource.configure do |config|
    config.clear!

    config.add_projections -> {
      [LoginProjection, ActiveClientProjection, ChannelProjection, MessageCableProjection]
    }
  end
end
