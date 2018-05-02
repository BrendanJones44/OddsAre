FactoryGirl.define do
  factory :task do
    association :winner, factory: :user
    association :loser, factory: :user
    action "MyString"
  end

end
