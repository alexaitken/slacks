class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_sign_in

  rescue_from 'VentSource::AggregateNotFound', with: :record_not_found

  private

  def authorize(person_id, auth_token)
    session[:authorized_person] = person_id
    session[:auth_token] = auth_token
  end

  def current_user
    if signed_in?
      @current_user ||= Person.find(session[:authorized_person])
    end
  end
  helper_method :current_user

  def signed_in?
    session[:authorized_person].present?
  end
  helper_method :signed_in?

  def require_sign_in
    redirect_to new_session_path unless current_user
  end

  def record_not_found
    render :file => 'public/404.html', :status => :not_found, :layout => false
  end
end
