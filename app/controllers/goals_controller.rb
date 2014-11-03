class GoalsController < ApplicationController
  before_action :require_signin
  
  def index
    @goals = Goal.all
  end
end
