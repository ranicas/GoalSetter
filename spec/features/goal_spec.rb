require 'spec_helper'
feature 'goals' do
  
  let(:cat_user) do
    user = FactoryGirl.build(:user)
    cat_user = User.find_by(username: user.username)
    cat_user.password = user.password
    cat_user
  end
  
  let(:dog_user) do
    user = FactoryGirl.build(:dog_user)
    dog_user = User.find_by(username: user.username)
    dog_user.password = user.password
    dog_user
  end
  
  let(:public_goal) do
     goal = FactoryGirl.build(:public_goal)
     goal.user_id = cat_user.id
     goal.save
     goal
   end
   
  let(:private_goal) do
     goal = FactoryGirl.build(:private_goal)
     goal.user_id = cat_user.id
     goal.save
     goal
   end
  
  before(:each) do
    sign_in(cat_user)
  end 

  after(:each) do
    sign_out
  end
  
  after(:all) do
    Goal.destroy_all
  end
  
  feature 'creating new goals' do
    
    before(:each)  do
      visit new_goal_url
    end

    scenario 'prompts for body and status' do
      expect(page).to have_content("Body")
      expect(page).to have_content("Status")
    end
  
 
    scenario 'require body and status input' do
      click_button "Create New Goal"
      expect(page).to have_content("Create New Goal")
    end

    scenario 'goal can be successfully created' do
      new_goal = FactoryGirl.build(:public_goal)
      fill_in "Body", with: new_goal.body
      select("Public", from: "Status")
      click_button "Create New Goal"
      expect(current_path).to match(/^\/goals\/(\d)+/)
    end

  end

  feature "goals have show pages" do

    scenario "public goal is visible to own user" do
      visit goal_url(public_goal)
      expect(page).to have_content(public_goal.body)
      expect(page).to have_content(public_goal.status)
    end

    scenario "private goal is visible to own user" do
      visit goal_url(private_goal)
      expect(page).to have_content(private_goal.body)
      expect(page).to have_content(private_goal.status)
    end

    scenario "goals should have delete and edit buttons" do
      visit goal_url(private_goal)
      expect(page).to have_link("Edit Goal")
      expect(page).to have_button("Delete Goal")
    end

    scenario "goals can be destroyed" do
      goal = FactoryGirl.build(:public_goal)
      goal.user_id = cat_user.id
      goal.save

      visit goal_url(goal)
      click_button("Delete Goal")
      expect(current_path).to match(/^\/goals$/)
      expect(page).to_not have_content(goal.body)
    end

    scenario "edit goal page link works" do
      visit goal_url(private_goal)
      click_link "Edit Goal"
      expect(current_path).to match(/^\/goals\/(\d)+\/edit/)
    end

    feature "as other user" do
      before(:each) do
        sign_out
        sign_in(dog_user)
      end

      scenario "public goal is visible to other user" do
        visit goal_url(public_goal)
        expect(page).to have_content(public_goal.body)
        expect(page).to have_content(public_goal.status)
      end

      scenario "private goal is not visible to other user" do
        visit goal_url(private_goal)
        expect(page).to_not have_content(private_goal.body)
        expect(page).to_not have_content(private_goal.status)
        expect(current_path).to match(/^\/goals$/)
      end

      scenario "delete and edit buttons should not be visible to other users" do
        visit goal_url(public_goal)
        expect(page).to_not have_link("Edit Goal")
        expect(page).to_not have_button("Delete Goal")
      end

    end
  end

  feature 'goals have index page' do
    before(:each) { visit goals_url }

    scenario 'index page has link to create new goal' do
      click_link "Create New Goal"
      expect(page).to have_content("Create New Goal")
    end

    scenario "index page has a list of goals viewable to user" do
      public_goal = cat_user.goals.where(status: "PUBLIC").first
      private_goal = cat_user.goals.where(status: "PRIVATE").first
      expect(page).to have_content(public_goal.body)
      expect(page).to have_content(private_goal.body)
    end

    scenario "user should not see other users' private goals" do
      sign_out
      sign_in(dog_user)
      public_goal = cat_user.goals.where(status: "PUBLIC").first
      private_goal = cat_user.goals.where(status: "PRIVATE").first
      expect(page).to_not have_content(private_goal.body)
      expect(page).to have_content(public_goal.body)
    end
  end

  feature "goals can be edited" do
    before(:each) { visit edit_goal_url(public_goal) }

    scenario 'prefills infomation for body and status' do
      expect(find_field('Body').value).to eq(public_goal.body)
      expect(find_field('Status').find('option[selected]').text).to eq(public_goal.status.downcase.capitalize)
    end

    scenario 'require body and status input' do
      fill_in 'Body', with: ""
      click_button "Edit Goal"
      expect(page).to have_content("Edit Goal")
    end

    scenario 'goal can be successfully edited' do
      text = SecureRandom.urlsafe_base64
      fill_in "Body", with: "#{text}"
      click_button "Edit Goal"
      expect(current_path).to match(/^\/goals\/(\d)+/)
      expect(page).to have_content(text)
    end

  end
    
end