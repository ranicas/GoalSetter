class GoalsController < ApplicationController
  before_action :require_signin
  before_action :require_same_user, only: [:edit, :update, :destroy]
  
  def new
    @goal = Goal.new
  end
  
  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user.id
    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end
  
  def show
    @goal = Goal.find(params[:id])
    if @goal.user_id != current_user.id && @goal.status == "PRIVATE"
      redirect_to goals_url
    else
      render :show
    end
  end
  
  def edit
    @goal = Goal.find(params[:id])
  end
  
  def update
    @goal = Goal.find(params[:id])
    if @goal.update(goal_params)
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end
  
  def index
    @goals = Goal.where("status = ? OR user_id = ?", "PUBLIC", current_user.id )
  end
  
  def destroy
    goal = Goal.find(params[:id])
    goal.destroy
    redirect_to goals_url
  end
  
  def goal_params
    params.require(:goal).permit(:body, :status)
  end
  
  def require_same_user
    goal = Goal.find(params[:id])
    redirect_to goals_url unless goal.user_id == current_user.id
  end
end
