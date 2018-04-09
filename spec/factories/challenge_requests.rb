FactoryGirl.define do
  factory :challenge_request do
    action { Faker::LeagueOfLegends.champion }
    association :notification, factory: :notification
  end
end
