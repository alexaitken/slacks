class Login < ActiveRecord::Base

  def self.signed_out(event)
    puts '[EVENT]signout'
  end
  def self.signed_in(event)
    puts '[EVENT]signin'
  end
  def self.signed_up(event)
    puts '[EVENT]signup'
  end
end
