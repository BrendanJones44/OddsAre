require 'rails_helper'
require './spec/support/odds_are_helpers'

RSpec.configure do |c|
  c.include OddsAreHelpers
end

RSpec.describe OddsAre, type: :model do
  it 'has a valid factory' do
    odds_are = build(:odds_are)
    expect(odds_are).to be_valid
  end

  describe '#user_can_view' do
    context 'odds are is not finalized' do
      subject { odds_are_with_no_finalization }
      context 'and user is the recipient' do
        it 'should return false' do
          expect(subject.user_can_view(subject.recipient))
            .to be false
        end
      end

      context 'and user is the initiator' do
        it 'should return false' do
          expect(subject.user_can_view(subject.initiator))
            .to be false
        end
      end

      context 'and user is not associated to the odds are' do
        it 'should return false' do
          expect(subject.user_can_view(build(:user)))
            .to be false
        end
      end
    end

    context 'odds are is finalized' do
      subject { odds_are_with_no_winner }
      context 'and user is the recipient' do
        it 'should return true' do
          expect(subject.user_can_view(subject.recipient))
            .to be true
        end
      end

      context 'and user is the initiator' do
        it 'should return true' do
          expect(subject.user_can_view(subject.initiator))
            .to be true
        end
      end

      context 'and user is not associated to the odds are' do
        it 'should return false' do
          expect(subject.user_can_view(build(:user)))
            .to be false
        end
      end
    end
  end

  describe '#initiator_won' do
    context 'odds are is not finalized' do
      subject { odds_are_with_no_finalization }
      it { expect(subject.initiator_won).to be false }
    end

    context 'odds are has no winner' do
      subject { odds_are_with_no_winner }
      it { expect(subject.initiator_won).to be false }
    end

    context 'odds are initiator won' do
      subject { odds_are_where_initiator_won }
      it { expect(subject.initiator_won).to be true }
    end

    context 'odds are recipient won' do
      subject { odds_are_where_recipient_won }
      it { expect(subject.initiator_won).to be false }
    end
  end

  describe '#recipient_won' do
    context 'odds are is not finalized' do
      subject { odds_are_with_no_finalization }
      it { expect(subject.recipient_won).to be false }
    end

    context 'odds are has no winner' do
      subject { odds_are_with_no_winner }
      it { expect(subject.recipient_won).to be false }
    end

    context 'odds are initiator won' do
      subject { odds_are_where_initiator_won }
      it { expect(subject.recipient_won).to be false }
    end

    context 'odds are recipient won' do
      subject { odds_are_where_recipient_won }
      it { expect(subject.recipient_won).to be true }
    end
  end
end
