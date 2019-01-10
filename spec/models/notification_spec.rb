require 'rails_helper'
require './spec/support/notification_helpers'

RSpec.configure do |c|
  c.include NotificationHelpers
end
RSpec.describe Notification, type: :model do
  it 'has a valid factory' do
    notification = build(:notification)
    expect(notification).to be_valid
  end

  describe '#user_can_update' do
    let(:non_associated_user) { FactoryGirl.create(:user) }
    context 'when notification has no recipient' do
      subject do
        FactoryGirl.create(:notification,
                           recipient: nil)
      end
      it { expect(subject.user_can_update(non_associated_user)).to be false }
    end

    context 'when notification has recipient' do
      let(:associated_user) { FactoryGirl.create(:user) }
      subject do
        FactoryGirl.create(:notification,
                           recipient: associated_user)
      end

      context 'and user is not associated' do
        it { expect(subject.user_can_update(non_associated_user)).to be false }
      end

      context 'and user is associated' do
        it { expect(subject.user_can_update(associated_user)).to be true }
      end
    end
  end

  describe '#to_s' do
    let(:actor) do
      FactoryGirl.create(:user,
                         first_name: 'Bob',
                         last_name: 'Smith')
    end
    subject do
      FactoryGirl.create(:notification,
                         actor: actor,
                         action: 'told you to test the code')
    end

    it { expect(subject.to_s).to eql 'Bob Smith told you to test the code' }
  end

  describe '#part_off_odds_are?' do
    context 'when notification is for a receiving a friend request' do
      subject { notification_from_receiving_friend_request }
      it 'returns false' do
        expect(subject.part_of_odds_are?).to be false
      end
    end

    context 'when notifcation is for someone accepting a friend request' do
      subject { notification_from_accepting_friend_request }
      it 'returns false' do
        expect(subject.part_of_odds_are?).to be false
      end
    end

    context 'when notification is for initiating an odds are' do
      subject { notification_from_initiating_odds_are }
      it 'returns true' do
        expect(subject.part_of_odds_are?).to be true
      end
    end

    context 'when notification is for responding to an odds are' do
      subject { notification_from_responding_odds_are }
      it 'returns true' do
        expect(subject.part_of_odds_are?).to be true
      end
    end

    context 'when notification is for finalizing an odds are' do
      subject { notification_from_finalizing_odds_are }
      it 'returns true' do
        expect(subject.part_of_odds_are?).to be true
      end
    end
  end

  describe '#odds_are' do
    context 'when notification is for a receiving a friend request' do
      subject { notification_from_receiving_friend_request }
      it 'returns nil' do
        expect(subject.odds_are).to be nil
      end
    end

    context 'when notification is for initiating an odds are' do
      subject { notification_from_initiating_odds_are }
      it 'returns an Odds Are' do
        expect(subject.odds_are).to be_a OddsAre
      end
    end

    context 'when notification is for responding to an odds are' do
      subject { notification_from_responding_odds_are }
      it 'returns an Odds Are' do
        expect(subject.odds_are).to be_a OddsAre
      end
    end

    context 'when notification is for finalizing an odds are' do
      subject { notification_from_finalizing_odds_are }
      it 'returns an Odds Are' do
        expect(subject.odds_are).to be_a OddsAre
      end
    end
  end
end
