require 'rails_helper'

RSpec.describe ChallengeFinalization, type: :model do
  it 'has a valid factory' do
    challenge_finalization = build(:challenge_finalization)
    expect(challenge_finalization).to be_valid
  end
end
