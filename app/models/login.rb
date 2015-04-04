class Login < ActiveRecord::Base
  def self.email_unique?(email_address)
    where(email_address: email_address).none?
  end
end
