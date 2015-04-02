class LoginProjection < VentSource::Projection
  projection_name 'login'

  define_filters do |filters|
    filters.push -> (event) { event.name != 'signed_up' }
  end

  def signed_up(event)
  end
end
