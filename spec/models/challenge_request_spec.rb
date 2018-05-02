require 'rails_helper'

RSpec.describe ChallengeRequest, type: :model do
  it "has a valid factory" do
    challenge_request = build(:challenge_request)
    expect( challenge_request ).to be_valid
  end

  it { is_expected.to validate_presence_of(:action).
                      with_message('You must say what the odds are is') }
end
