class SessionsController < ApplicationController
  before_action :require_signin, only: [:destroy]
  before_action :require_signout, only: [:create, :new]
  def new
    @user = User.new
  end
  
  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )
    
    if @user
      sign_in!(@user)
      redirect_to goals_url
    else
      flash.now[:errors] = ["invalid username and password combination"]
      @user = User.new(username: params[:user][:username])
      render :new
    end
  end
  
  def destroy
    sign_out!
    redirect_to new_session_url
  end
end
