require 'spec_helper'

feature "Comments" do 
  user = FactoryGirl.build(:user)
  cat_user = User.find_by(username: user.username)
  cat_user.password = user.password


  user = FactoryGirl.build(:dog_user)
  dog_user = User.find_by(username: user.username)
  dog_user.password = user.password
  
  before(:all) do
    goal = FactoryGirl.build(:public_goal)
    goal.user_id = cat_user.id
    goal.save
  
    goal = FactoryGirl.build(:private_goal)
    goal.user_id = cat_user.id
    goal.save
  end

  let(:cat_user) { cat_user }

  let(:dog_user) { dog_user }

  let(:public_goal) { cat_user.goals.where(status: "PUBLIC").first }
 
  let(:private_goal) { cat_user.goals.where(status: "PRIVATE").first }
  
  before(:each) do
    sign_in(cat_user)
  end 

  after(:each) do
    sign_out
  end
  
  after(:all) do
    Goal.destroy_all
  end
  
  feature "On Goals" do
    scenario "comment form appears on Goal show page" do
      visit goal_url(public_goal)
    end
  end
  
  feature "On Users" do
    
  end
end