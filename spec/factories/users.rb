FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(6)}
    created_at { Faker::Time.between(14.days.ago, 10.days.ago, :all) }
    # Guarentee the updated_at after created_at
    updated_at { Faker::Time.between(9.days.ago, Date.today, :all) }
    sign_in_count { Faker::Number.between(1,200) }
    user_name { Faker::LeagueOfLegends.champion }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
