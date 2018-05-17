require 'rails_helper'

RSpec.describe ChallengeResponse, type: :model do
  it 'has a valid factory' do
    challenge_response = build(:challenge_response)
    expect(challenge_response).to be_valid
  end

  it {
    is_expected.to validate_presence_of(:odds_out_of)
      .with_message('You must say what the odds are out of')
  }

  it {
    is_expected.to validate_presence_of(:number_chosen)
      .with_message('You must pick a number')
  }

  describe '#odds_out_of_min' do
    context 'with odds out of being too small' do
      let(:challenge_response) do
        ChallengeResponse.create(number_chosen: 1, odds_out_of: 2)
      end
      it {
        expect(challenge_response.errors[:odds_out_of].first)
          .to eq 'Odds are must be out of a minimum of 3'
      }
    end

    context 'with odds out of being in range' do
      let(:challenge_response) do
        ChallengeResponse.create(number_chosen: 1, odds_out_of: 3)
      end
      it { expect(challenge_response.errors[:odds_out_of].size).to eq 0 }
    end
  end

  describe '#number_chosen_not_middle' do
    context 'with number chosen being in the middle' do
      let(:challenge_response) do
        ChallengeResponse.create(number_chosen: 2, odds_out_of: 4)
      end
      it {
        expect(challenge_response.errors[:number_chosen].first)
          .to eq 'Your number cannot be the middle number' \
        ' (if the challenger chooses this, both of you would lose)'
      }
    end

    context 'with number chosen not being in the middle' do
      let(:challenge_response) do
        ChallengeResponse.create(number_chosen: 1, odds_out_of: 3)
      end
      it { expect(challenge_response.errors[:number_chosen].size).to eq 0 }
    end
  end

  describe '#number_chosen_in_bounds' do
    context 'with number chosen being equal to what it is set out of' do
      let(:challenge_response) do
        ChallengeResponse.create(number_chosen: 3, odds_out_of: 3)
      end
      it {
        expect(challenge_response.errors[:number_chosen].first)
          .to eq 'Your number must be less than what the odds are out of'
      }
    end

    context 'with number chosen being greater than what it is set out of' do
      let(:challenge_response) do
        ChallengeResponse.create(number_chosen: 4, odds_out_of: 3)
      end
      it {
        expect(challenge_response.errors[:number_chosen].first)
          .to eq 'Your number must be less than what the odds are out of'
      }
    end

    context 'with number chosen being smaller than 1' do
      let(:challenge_response) do
        ChallengeResponse.create(number_chosen: 0, odds_out_of: 3)
      end
      it {
        expect(challenge_response.errors[:number_chosen].first)
          .to eq 'Your number must be at least 1'
      }
    end

    context 'with number chosen being in range' do
      let(:challenge_response) do
        ChallengeResponse.create(number_chosen: 1, odds_out_of: 3)
      end
      it { expect(challenge_response.errors[:number_chosen].size).to eq 0 }
    end
  end
end
