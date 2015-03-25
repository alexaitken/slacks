module VentSource::IdGeneration
  def generate_id
    SecureRandom.uuid
  end
end
