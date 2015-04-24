class LoginProjection < VentSource::Projection
  projection_name 'login'

  def self.reset_projection_records
    Login.delete_all
  end

  def signed_in(event)
    login = Login.find_by(aggregate_id: event.aggregate_id)
    login.sign_ins += 1
    login.save
  end

  def signed_up(event)
    Login.create aggregate_id: event.aggregate_id, email_address: event.data['email_address'], name: event.data['name'], sign_ins: 0
  end
end
