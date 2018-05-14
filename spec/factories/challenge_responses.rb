FactoryGirl.define do
  factory :challenge_response do
    odds_out_of { Faker::Number.between(10, 100) }
    number_chosen { Faker::Number.between(1, 9) }
    association :odds_are, factory: :odds_are
  end
end
