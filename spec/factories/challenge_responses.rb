FactoryGirl.define do
  factory :challenge_response do
    odds_out_of { Faker::Number.between(10, 100) }
    number_chosen { 1 }
    association :odds_are, factory: :odds_are
  end
end
