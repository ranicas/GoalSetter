require 'spec_helper'

feature "the signup process" do 
  before(:each) { visit new_user_url }

  it "has a new user page" do
    expect(page).to have_content("Sign Up")
  end
  
  it "takes a username and password" do
    expect(page).to have_content("Username")
    expect(page).to have_content("Password")
  end

  feature "signing up a user" do

    it "shows username on the homepage after signup" do
      user = FactoryGirl.build(:user)
      sign_up(user)
      expect(page).to have_content(user.username)
    end
    
    it "shows sign up page again if failed to signup" do
      user = FactoryGirl.build(:invalid_user)
      sign_up(user)
      expect(page).to have_content("Sign Up")
    end
  end

end

feature "signing in" do 

  it "shows username on the homepage after sign in" do
    user = FactoryGirl.build(:user)
    sign_in(user)
    expect(page).to have_content(user.username)
  end
  
  it "shows sign in page again if failed to sign in" do
    user = FactoryGirl.build(:invalid_user)
    sign_in(user)
    expect(page).to have_content("Sign In")
  end
end

feature "signing out" do 

  it "begins with signed out state" do
    visit new_session_url
    expect(page).to_not have_content("Sign Out")
  end

  it "doesn't show username on the homepage after sign out" do
    user = FactoryGirl.build(:user)
    sign_in(user)
    sign_out(user)
    expect(page).to_not have_content(user.username)
    expect(page).to have_content("Sign In")
  end

end