class ActiveClientProjection < VentSource::Projection

  projection_name 'active_client'

  def self.reset_projection_records
    ActiveClient.delete_all
  end

  def signed_in(event)
    ActiveClient.create!(aggregate_id: event.aggregate_id, name: event.data['client'], auth_token: event.data['auth_token'])
  end

  def signed_out(event)
    client = ActiveClient.find_by(aggregate_id: event.aggregate_id, auth_token: event.data['auth_token'])
    client.destroy if client
  end
end
