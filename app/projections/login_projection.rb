class LoginProjection < VentSource::Projection
  projection_name 'login'

  def signed_in(event)
    login = Login.find_by(aggregate_id: event.aggregate_id)
    login.sign_ins += 1
    login.save
  end

  def signed_up(event)
    Login.create aggregate_id: event.aggregate_id, email_address: event.data['email_address'], sign_ins: 0
  end
end
