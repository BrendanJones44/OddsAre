FactoryGirl.define do
  factory :odds_are do
    association :recipient, factory: :user
    association :initiator, factory: :user
    association :challenge_request, factory: :challenge_request
  end
end
