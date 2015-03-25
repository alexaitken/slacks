class SignupsController < ApplicationController
  skip_before_action :require_sign_in

  def new
    @signup = Command::Signup.new
  end

  def create
    @signup = Command::Signup.new signup_params

    if @signup.valid?
      p = Person.new

      if @signup.execute(p) && p.commit
        @sign_in = Command::SignIn.new auth_token: SecureRandom.hex, client: 'web'
        if @sign_in.execute(p) && p.commit
          authorize(@signup.person_id, @sign_in.auth_token)
        end
        redirect_to home_path
      else
        render 'new'
      end
    else
      render 'new'
    end
  end

  private

  def signup_params
    params.require(:signup).permit(:name, :display_name, :email_address, :password)
  end
end
