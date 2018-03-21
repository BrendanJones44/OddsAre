FactoryGirl.define do
  factory :challenge_request do
    action { Faker::LeagueOfLegends.champion }
  end
end
