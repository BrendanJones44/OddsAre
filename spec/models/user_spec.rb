require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |c|
  c.include UserHelpers
end

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    user = build(:user)
    expect(user).to be_valid
  end

  describe User do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:user_name) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }

    describe '#full_name' do
      it 'returns the full name' do
        user = build(:user)
        user.update_attribute(:first_name, 'Bob')
        user.update_attribute(:last_name, 'Mill')
        expect(user.full_name).to eql('Bob Mill')
      end
    end

    describe '#has_friends' do
      context 'user has no friends' do
        subject { FactoryGirl.create :user }
        it { expect(subject.has_friends).to be false }
      end

      context 'user has friends' do
        subject { user_with_friends }
        it { expect(subject.has_friends).to be true }
      end
    end

    describe '#has_friend_requests' do
      context 'user has no friend requests' do
        subject { FactoryGirl.create :user }
        it { expect(subject.has_friend_requests).to be false }
      end

      context 'user has a friend request' do
        subject { user_with_friend_request }
        it { expect(subject.has_friend_requests).to be true }
      end
    end

    describe '#user_name' do
      context 'user name contains profanity' do
        subject { FactoryGirl.create :user }
        before { subject.update_attribute(:user_name, 'fuck') }
        it { expect(subject).to be_invalid }
      end
    end

    describe '#first_name' do
      context 'user name contains profanity' do
        subject { FactoryGirl.create :user }
        before { subject.update_attribute(:first_name, 'fuck') }
        it { expect(subject).to be_invalid }
      end
    end

    describe '#last_name' do
      context 'user name contains profanity' do
        subject { FactoryGirl.create :user }
        before { subject.update_attribute(:last_name, 'fuck') }
        it { expect(subject).to be_invalid }
      end
    end

    describe '#total_odds_ares' do
      context 'where user has no odds ares' do
        subject { FactoryGirl.create :user }
        it { expect(subject.total_odds_ares).to eql [] }
      end

      context 'where user has multiple odds ares' do
        subject { user_with_complete_odds_are_where_nobody_wins }
        it { expect(subject.total_odds_ares.size).to eql 1 }
      end
    end

    describe '#completed_odds_ares' do
      context 'where user has no odds ares at all' do
        subject { FactoryGirl.create :user }
        it { expect(subject.completed_odds_ares).to eql [] }
      end

      context 'where user had an odds are with no response' do
        subject { user_with_unresponded_odds_are }
        it { expect(subject.completed_odds_ares).to eql [] }
      end

      context 'where user has an odds are with no finalization' do
        subject { user_with_unfinalized_odds_are }
        it { expect(subject.completed_odds_ares).to eql [] }
      end

      context 'where user has an odds are that has been completed' do
        subject { user_with_complete_odds_are_where_nobody_wins }
        it { expect(subject.completed_odds_ares.size).to eql 1 }
      end
    end

    describe '#has_lost_odds_ares' do
      context 'where user has no odds ares' do
        subject { FactoryGirl.create :user }
        it { expect(subject.has_lost_odds_ares).to be false }
      end

      context 'where user has lost odds ares' do
        subject { user_with_lost_odds_are }
        it { expect(subject.has_lost_odds_ares). to be true }
      end

      context 'where user only has won odds ares' do
        subject { user_with_won_odds_are }
        it { expect(subject.has_lost_odds_ares). to be false }
      end
    end

    describe '#has_current_odds_ares' do
      context 'where user has no odds ares at all' do
        subject { FactoryGirl.create :user }
        it { expect(subject.has_current_odds_ares).to be false }
      end

      context 'where user had an odds are with no response' do
        subject { user_with_unresponded_odds_are }
        it { expect(subject.has_current_odds_ares).to be true }
      end

      context 'where user has an odds are with no finalization' do
        subject { user_with_unfinalized_odds_are }
        it { expect(subject.has_current_odds_ares).to be true }
      end

      context 'where user has an odds are that has been completed' do
        subject { user_with_complete_odds_are_where_nobody_wins }
        it { expect(subject.has_current_odds_ares).to be false }
      end
    end

    describe '#num_current_odds_ares' do
      context 'where user has no odds ares at all' do
        subject { FactoryGirl.create :user }
        it { expect(subject.num_current_odds_ares).to eql 0 }
      end

      context 'where user had an odds are with no response' do
        subject { user_with_unresponded_odds_are }
        it { expect(subject.num_current_odds_ares).to eql 1 }
      end

      context 'where user has an odds are with no finalization' do
        subject { user_with_unfinalized_odds_are }
        it { expect(subject.num_current_odds_ares).to eql 1 }
      end

      context 'where user has an odds are that has been completed' do
        subject { user_with_complete_odds_are_where_nobody_wins }
        it { expect(subject.num_current_odds_ares).to eql 0 }
      end
    end

    describe '#dares_completed' do
      context 'where user has no odds ares' do
        subject { FactoryGirl.create :user }
        it { expect(subject.dares_completed).to match_array([]) }
      end

      context 'where user is the winner' do
        subject { user_with_won_odds_are }
        it { expect(subject.dares_completed). to match_array([]) }
      end

      context 'where user is the loser' do
        subject { user_with_lost_odds_are }
        context 'and user has not reported the dare complete' do
          before do
            subject.lost_odds_ares.first.update_attribute(:loser_marked_completed_at, nil)
          end
          it { expect(subject.dares_completed). to match_array([]) }
          context 'and winner has reported the dare complete' do
            before do
              subject.lost_odds_ares.first.update_attribute(:winner_marked_completed_at, Time.zone.now)
            end
            it { expect(subject.dares_completed). to match_array([]) }
          end

          context 'and winner has not reported the dare complete' do
            before do
              subject.lost_odds_ares.first.update_attribute(:winner_marked_completed_at, nil)
            end
            it { expect(subject.dares_completed). to match_array([]) }
          end
        end

        context 'and user has reported the dare complete' do
          before do
            subject.lost_odds_ares.first.update_attribute(:loser_marked_completed_at, Time.zone.now)
          end
          it { expect(subject.dares_completed). to match_array([]) }
          context 'and winner has reported the dare complete' do
            before do
              subject.lost_odds_ares.first.update_attribute(:winner_marked_completed_at, Time.zone.now)
            end
            it { expect(subject.dares_completed). to match_array(subject.lost_odds_ares) }
          end

          context 'and winner has not reported the dare complete' do
            before do
              subject.lost_odds_ares.first.update_attribute(:winner_marked_completed_at, nil)
            end
            it { expect(subject.dares_completed). to match_array([]) }
          end
        end
      end
    end

    describe '#challenge_requests_waiting_on_user_to_set' do
      context 'where user has no odds ares at all' do
        subject { FactoryGirl.create :user }
        it { expect(subject.challenge_requests_waiting_on_user_to_set). to match_array([]) }
      end

      context 'where user is initiator of the odds are' do
        context 'where there is no response' do
          subject { user_initiating_odds_are_with_no_response }
          it { expect(subject.challenge_requests_waiting_on_user_to_set). to match_array([]) }
        end

        context 'where there is no finalization' do
          subject { user_initiating_odds_are_with_no_finalization }
          it { expect(subject.challenge_requests_waiting_on_user_to_set). to match_array([]) }
        end

        context 'where the odds are is finalzed' do
          subject { user_initiating_odds_are_that_is_complete }
          it { expect(subject.challenge_requests_waiting_on_user_to_set). to match_array([]) }
        end
      end

      context 'where user is recipient of the odds are' do
        context 'where there is no response' do
          subject { user_receiving_odds_are_with_no_response }
          it { expect(subject.challenge_requests_waiting_on_user_to_set). to match_array(subject.received_odds_ares.first.challenge_request) }
        end

        context 'where there is no finalization' do
          subject { user_receiving_odds_are_with_no_finalization }
          it { expect(subject.challenge_requests_waiting_on_user_to_set). to match_array([]) }
        end

        context 'where the odds are is finalzed' do
          subject { user_receiving_odds_are_that_is_complete }
          it { expect(subject.challenge_requests_waiting_on_user_to_set). to match_array([]) }
        end
      end
    end

    describe '#challenge_responses_waiting_on_user_to_complete' do
      context 'where user has no odds ares at all' do
        subject { FactoryGirl.create :user }
        it { expect(subject.challenge_responses_waiting_on_user_to_complete). to match_array([]) }
      end

      context 'where user is initiator of the odds are' do
        context 'where there is no response' do
          subject { user_initiating_odds_are_with_no_response }
          it { expect(subject.challenge_responses_waiting_on_user_to_complete). to match_array([]) }
        end

        context 'where there is no finalization' do
          subject { user_initiating_odds_are_with_no_finalization }
          it { expect(subject.challenge_responses_waiting_on_user_to_complete). to match_array(subject.sent_odds_ares.first.challenge_response) }
        end

        context 'where the odds are is finalzed' do
          subject { user_initiating_odds_are_that_is_complete }
          it { expect(subject.challenge_responses_waiting_on_user_to_complete). to match_array([]) }
        end
      end

      context 'where user is recipient of the odds are' do
        context 'where there is no response' do
          subject { user_receiving_odds_are_with_no_response }
          it { expect(subject.challenge_responses_waiting_on_user_to_complete). to match_array([]) }
        end

        context 'where there is no finalization' do
          subject { user_receiving_odds_are_with_no_finalization }
          it { expect(subject.challenge_responses_waiting_on_user_to_complete). to match_array([]) }
        end

        context 'where the odds are is finalzed' do
          subject { user_receiving_odds_are_that_is_complete }
          it { expect(subject.challenge_responses_waiting_on_user_to_complete). to match_array([]) }
        end
      end
    end

    describe '#challenge_requests_waiting_on_friends_to_set' do
      context 'where user has no odds ares at all' do
        subject { FactoryGirl.create :user }
        it { expect(subject.challenge_requests_waiting_on_friends_to_set). to match_array([]) }
      end

      context 'where user is initiator of the odds are' do
        context 'where there is no response' do
          subject { user_initiating_odds_are_with_no_response }
          it { expect(subject.challenge_requests_waiting_on_friends_to_set). to match_array(subject.sent_odds_ares.first.challenge_request) }
        end

        context 'where there is no finalization' do
          subject { user_initiating_odds_are_with_no_finalization }
          it { expect(subject.challenge_requests_waiting_on_friends_to_set). to match_array([]) }
        end

        context 'where the odds are is finalzed' do
          subject { user_initiating_odds_are_that_is_complete }
          it { expect(subject.challenge_requests_waiting_on_friends_to_set). to match_array([]) }
        end
      end

      context 'where user is recipient of the odds are' do
        context 'where there is no response' do
          subject { user_receiving_odds_are_with_no_response }
          it { expect(subject.challenge_requests_waiting_on_friends_to_set). to match_array([]) }
        end

        context 'where there is no finalization' do
          subject { user_receiving_odds_are_with_no_finalization }
          it { expect(subject.challenge_requests_waiting_on_friends_to_set). to match_array([]) }
        end

        context 'where the odds are is finalzed' do
          subject { user_receiving_odds_are_that_is_complete }
          it { expect(subject.challenge_requests_waiting_on_friends_to_set). to match_array([]) }
        end
      end
    end

    describe '#challenge_responses_waiting_on_friends_to_complete' do
      context 'where user has no odds ares at all' do
        subject { FactoryGirl.create :user }
        it { expect(subject.challenge_responses_waiting_on_friends_to_complete). to match_array([]) }
      end

      context 'where user is initiator of the odds are' do
        context 'where there is no response' do
          subject { user_initiating_odds_are_with_no_response }
          it { expect(subject.challenge_responses_waiting_on_friends_to_complete). to match_array([]) }
        end

        context 'where there is no finalization' do
          subject { user_initiating_odds_are_with_no_finalization }
          it { expect(subject.challenge_responses_waiting_on_friends_to_complete). to match_array([]) }
        end

        context 'where the odds are is finalzed' do
          subject { user_initiating_odds_are_that_is_complete }
          it { expect(subject.challenge_responses_waiting_on_friends_to_complete). to match_array([]) }
        end
      end

      context 'where user is recipient of the odds are' do
        context 'where there is no response' do
          subject { user_receiving_odds_are_with_no_response }
          it { expect(subject.challenge_responses_waiting_on_friends_to_complete). to match_array([]) }
        end

        context 'where there is no finalization' do
          subject { user_receiving_odds_are_with_no_finalization }
          it { expect(subject.challenge_responses_waiting_on_friends_to_complete). to match_array(subject.received_odds_ares.first.challenge_response) }
        end

        context 'where the odds are is finalzed' do
          subject { user_receiving_odds_are_that_is_complete }
          it { expect(subject.challenge_responses_waiting_on_friends_to_complete). to match_array([]) }
        end
      end
    end
  end
end
