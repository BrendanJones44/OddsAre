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

  describe '#should_update_notification' do
    context 'odds are is not finalized' do
      subject { odds_are_with_no_finalization }
      context 'and user is the recipient' do
        it 'should be false' do
          expect(subject.should_update_notification(subject.recipient))
            .to be false
        end
      end

      context 'and user is the initiator' do
        it 'should be false' do
          expect(subject.should_update_notification(subject.initiator))
            .to be false
        end
      end

      context 'and user is not associated with the odds are' do
        it 'should be false' do
          expect(subject.should_update_notification(build(:user)))
            .to be false
        end      end
    end

    context 'odds are is finalized' do
      subject { odds_are_where_initiator_won }
      context 'and user is the recipient' do
        it 'should be true' do
          expect(subject.should_update_notification(subject.recipient))
            .to be true
        end
      end

      context 'and user is the initiator' do
        it 'should be false' do
          expect(subject.should_update_notification(subject.initiator))
            .to be false
        end
      end

      context 'and user is not associated with the odds are' do
        it 'should be false' do
          expect(subject.should_update_notification(build(:user)))
            .to be false
        end
      end

      context 'and notification has already been marked' do
        before { subject.notification.update(acted_upon_at: Time.zone.now) }
        context 'and user is the recipient' do
          it 'should be false' do
            expect(subject.should_update_notification(subject.recipient))
              .to be false
          end
        end

        context 'and user is the initiator' do
          it 'should be false' do
            expect(subject.should_update_notification(subject.initiator))
              .to be false
          end
        end

        context 'and user is not associated with the odds are' do
          it 'should be false' do
            expect(subject.should_update_notification(build(:user)))
              .to be false
          end
        end
      end
    end
  end

  describe '#other_user' do
    context 'as recipient' do
      subject { odds_are_where_recipient_won }
      it {
        expect(subject.other_user(subject.recipient))
          .to be subject.initiator
      }
    end

    context 'as initiator' do
      subject { odds_are_where_initiator_won }
      it {
        expect(subject.other_user(subject.initiator))
          .to be subject.recipient
      }
    end

    context 'as a non-associated user' do
      subject { odds_are_where_initiator_won }
      it { expect(subject.other_user(build(:user))).to be nil }
    end
  end

  describe '#result' do
    context 'with incomplete odds are' do
      subject { odds_are_with_no_finalization }
      it { expect(subject.result(subject.initiator)).to eql 'In progress' }
    end

    context 'with no winner' do
      subject { odds_are_with_no_winner }
      it { expect(subject.result(subject.initiator)).to eql 'Nobody won' }
    end

    context 'as winner' do
      subject { odds_are_where_initiator_won }
      it { expect(subject.result(subject.initiator)).to eql 'You won!' }
    end

    context 'as loser' do
      subject { odds_are_where_initiator_won }
      it { expect(subject.result(subject.recipient)).to eql 'You lost!' }
    end

    context 'as a non-associated user' do
      subject { odds_are_where_initiator_won }
      it { expect(subject.result(build(:user))).to be nil }
    end
  end

  describe '#responder_name' do
    context 'with no response' do
      subject { odds_are_with_no_response }
      it {
        expect(subject.responder_name(subject.recipient))
          .to eql 'Nobody responded'
      }
    end

    context 'as the initiator' do
      subject { odds_are_where_initiator_won }
      it {
        expect(subject.responder_name(subject.initiator))
          .to eql subject.recipient.full_name
      }
    end

    context 'as the recipient' do
      subject { odds_are_where_recipient_won }
      it { expect(subject.responder_name(subject.recipient)).to eql 'You' }
    end

    context 'as a non-associated user' do
      subject { odds_are_where_recipient_won }
      it { expect(subject.responder_name(build(:user))).to be nil }
    end
  end

  describe '#initiator_name' do
    context 'as the initiator' do
      subject { odds_are_where_initiator_won }
      it { expect(subject.initiator_name(subject.initiator)).to eql 'You' }
    end

    context 'as the recipient' do
      subject { odds_are_where_recipient_won }
      it {
        expect(subject.initiator_name(subject.recipient))
          .to eql subject.initiator.full_name
      }
    end

    context 'as a non-associated user' do
      subject { odds_are_where_recipient_won }
      it { expect(subject.initiator_name(build(:user))).to be nil }
    end
  end
end
