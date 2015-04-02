class Login < ActiveRecord::Base

  def self.signed_out(event)
  end

  def self.signed_in(event)
    login = find_by(aggregate_id: event.aggregate_id)
    login.sign_ins += 1
    login.save
  end

  def self.signed_up(event)
    create aggregate_id: event.aggregate_id, email_address: event.data['email_address'], sign_ins: 0
  end
end
