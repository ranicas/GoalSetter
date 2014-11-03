FactoryGirl.define do
  factory :user do
    username "coolcat29"
    password "iH4zh4tz"
  end
  
  factory :dog_user do
    username "cooldawg1337"
    password "iH4zT34C001"
  end
  
  factory :invalid_user, class: User do
    username ""
    password ""
  end
 
end



