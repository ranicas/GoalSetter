class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?
  
  def current_user
    User.find_by(session_token: session[:session_token])
  end
  
  def signed_in?  
    !!current_user
  end
  
  def require_signin
    redirect_to new_session_url unless signed_in?
  end
  
  def require_signout
    redirect_to goals_url if signed_in?
  end
  
  def sign_in!(user)
    session[:session_token] = user.reset_session_token!
  end
  
  def sign_out!
    current_user.reset_session_token!
    session[:session_token] = nil
  end
  
end
