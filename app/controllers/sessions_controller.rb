class SessionsController < ApplicationController

  class SignInForm
    include ActiveModel::Model

    attr_accessor :email_address, :password

    validates :email_address, presence: true
    validates :password, presence: true

    def self.model_name
      ActiveModel::Name.new(self, nil, 'SignIn')
    end

    def find_person
      login = Login.find_by(email_address: email_address)
      Person.find(login.aggregate_id)
    end
  end

  skip_before_action :require_sign_in

  def new
    @sign_in_form = SignInForm.new
  end

  def create
    @sign_in_form = SignInForm.new sign_in_params


    if @sign_in_form.valid? && person = @sign_in_form.find_person
      sign_in = SignIn.new auth_token: SecureRandom.hex, client: 'web', password: sign_in_params[:password]

      if sign_in.execute(person) && person.commit
        authorize(person.id, sign_in.auth_token)
        redirect_to home_path, success: "welcome"
      else
        byebug
        render :new, error: "no dice today"
      end
    else
      render :new, error: "no dice today"
    end
  end

  def destroy
    @person = current_user

    @sign_out = SignOut.new auth_token: session[:auth_token]

    if @sign_out.execute(@person) && @person.commit
      session[:authorized_person] = nil
      session[:auth_token] = nil
      redirect_to new_session_path
    else
      redirect_to home_path, error: "You were not signed out, I'm really sorry."
    end

  end

  private

  def sign_in_params
    params.require(:sign_in).permit(:email_address, :password)
  end
end
