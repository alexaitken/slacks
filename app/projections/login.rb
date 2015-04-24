class Login < ActiveRecord::Base
  def self.email_unique?(email_address)
    where(email_address: email_address).none?
  end

  def self.person_exists?(id)
    exists?(aggregate_id: id)
  end
end
