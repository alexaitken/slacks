class SignUpsController < ApplicationController
  skip_before_action :require_sign_in

  def new
    @sign_up = SignUp.new
  end

  def create
    @sign_up = SignUp.new sign_up_params

    if @sign_up.valid?
      p = Person.new

      if @sign_up.execute(p) && p.commit
        @sign_in = SignIn.new auth_token: SecureRandom.hex, client: 'web', password: sign_up_params[:password]
        if @sign_in.execute(p) && p.commit
          authorize(@sign_up.person_id, @sign_in.auth_token)
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

  def sign_up_params
    params.require(:sign_up).permit(:name, :display_name, :email_address, :password)
  end
end
