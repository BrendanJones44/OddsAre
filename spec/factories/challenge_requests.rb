FactoryGirl.define do
  factory :challenge_request do
    created_at { Faker::Time.between(14.days.ago, 10.days.ago, :all) }
    # Guarentee the updated_at after created_at
    updated_at { Faker::Time.between(9.days.ago, Date.today, :all) }
  end
end
