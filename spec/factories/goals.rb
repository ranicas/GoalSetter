FactoryGirl.define do
  factory :private_goal, class: Goal do
    body do
      Faker::Hacker.say_something_smart
    end
    status "PRIVATE"
  end
  
  factory :public_goal, class: Goal do
    body do
      Faker::Hacker.say_something_smart
    end
    status "PUBLIC"
  end

end
