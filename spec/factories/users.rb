FactoryGirl.define do
  factory :user do
    username "coolcat29"
    password "iH4zh4tz"
  end
  
  factory :invalid_user, class: User do
    username ""
    password ""
  end
 
end



