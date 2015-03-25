class SessionsController < ApplicationController
  skip_before_action :require_sign_in

  def new
  end

  def create
    username = sign_in_params[:name]
    @person = Person.all.detect { |p| p.name == username && p.password == sign_in_params[:password]}
    byebug
    if @person
      authorized_person(@person)
      redirect_to home_path
    else
      render :new
    end
  end

  def destroy
    session[:authorized_person] = nil
    redirect_to new_session_path
  end

  private

  def sign_in_params
    params.require(:sign_in).permit(:name, :password)
  end
end
