class SessionsController < ApplicationController
  skip_before_action :require_sign_in

  def new
  end

  def create
    email_address = sign_in_params[:email_address]
    @person = Person.all.detect { |p| p.email_address == email_address && p.password == sign_in_params[:password]}

    if @person
      @sign_in = Command::SignIn.new auth_token: SecureRandom.hex, client: 'web'
      if @sign_in.execute(p) && p.commit
        authorize(@sign_up.person_id, @sign_in.auth_token)
      end
      redirect_to home_path
    else
      render :new
    end
  end

  def destroy
    @person = current_user

    @sign_out = Command::SignOut.new auth_token: session[:auth_token]

    if @sign_out.execute(p) && p.commit
      session[:authorized_person] = nil
      session[:auth_token] = nil
      redirect_to new_session_path
    else
      redirect_to home_path
    end

  end

  private

  def sign_in_params
    params.require(:sign_in).permit(:name, :password)
  end
end
