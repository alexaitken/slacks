class SessionsController < ApplicationController
  skip_before_action :require_sign_in

  def new
  end

  def create
    email_address = sign_in_params[:email_address]
    @person = Person.all.detect { |p|
      p.email_address == email_address && p.password == sign_in_params[:password]
    }

    if @person
      @sign_in = Command::SignIn.new auth_token: SecureRandom.hex, client: 'web'
      if @sign_in.execute(@person) && @person.commit
        authorize(@person.id, @sign_in.auth_token)
      end
      redirect_to home_path, success: "welcome"
    else
      render :new, error: "no dice today"
    end
  end

  def destroy
    @person = current_user

    @sign_out = Command::SignOut.new auth_token: session[:auth_token]

    if @sign_out.execute(@person) && @person.commit
      session[:authorized_person] = nil
      session[:auth_token] = nil
      redirect_to new_session_path
    else
      redirect_to home_path, error: "you were not signed out im really sorry."
    end

  end

  private

  def sign_in_params
    params.require(:sign_in).permit(:email_address, :password)
  end
end
