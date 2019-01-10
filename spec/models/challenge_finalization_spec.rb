require 'rails_helper'
require './spec/support/odds_are_helpers'

RSpec.configure do |c|
  c.include OddsAreHelpers
end

RSpec.describe ChallengeFinalization, type: :model do
  it 'has a valid factory' do
    challenge_finalization = build(:challenge_finalization)
    expect(challenge_finalization).to be_valid
  end

  describe '#number_chosen_not_middle' do
    context 'with number chosen being in the middle' do
      let(:odds_are) { odds_are_with_no_finalization }
      let(:challenge_finalization) do
        ChallengeFinalization.create(number_guessed: odds_are.odds_out_of / 2,
                                     odds_are_id: odds_are.id)
      end

      it {
        expect(challenge_finalization.errors[:number_guessed].first)
          .to eq 'Your number cannot be the middle number' \
        ' (if this was the number, both of you would lose)'
      }
    end

    context 'with number chosen not being in the middle' do
      let(:odds_are) { odds_are_with_no_finalization }
      let(:challenge_finalization) do
        ChallengeFinalization.create(number_guessed: odds_are.odds_out_of - 1,
                                     odds_are_id: odds_are.id)
      end

      it {
        expect(challenge_finalization).to be_valid
      }
    end
  end
end
