require 'rails_helper'

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
end
