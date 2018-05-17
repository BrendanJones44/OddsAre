require_relative './odds_are_helpers'

# Collection of helper methods to get various instances of a user
# Each instance has a slightly modified state/association
module UserHelpers
  def user_with_friends
    user_a = FactoryGirl.create :user
    user_b = FactoryGirl.create :user
    user_a.friend_request(user_b)
    user_b.accept_request(user_a)
    user_a
  end

  def user_with_friend_request
    user_a = FactoryGirl.create :user
    user_b = FactoryGirl.create :user
    user_a.friend_request(user_b)
    user_b
  end

  def user_with_complete_odds_are_where_nobody_wins
    OddsAreHelpers.odds_are_with_no_winner.initiator
  end

  def user_with_unresponded_odds_are
    OddsAreHelpers.odds_are_with_no_response.initiator
  end

  def user_with_unfinalized_odds_are
    OddsAreHelpers.odds_are_with_no_finalization.initiator
  end

  def user_with_won_odds_are
    OddsAreHelpers.odds_are_where_initiator_won.task.winner
  end

  def user_with_lost_odds_are
    OddsAreHelpers.odds_are_where_initiator_won.task.loser
  end

  def user_initiating_odds_are_with_no_response
    OddsAreHelpers.odds_are_with_no_response.initiator
  end

  def user_initiating_odds_are_with_no_finalization
    OddsAreHelpers.odds_are_with_no_finalization.initiator
  end

  def user_initiating_odds_are_that_is_complete
    OddsAreHelpers.odds_are_with_no_winner.initiator
  end

  def user_receiving_odds_are_with_no_response
    OddsAreHelpers.odds_are_with_no_response.recipient
  end

  def user_receiving_odds_are_with_no_finalization
    OddsAreHelpers.odds_are_with_no_finalization.recipient
  end

  def user_receiving_odds_are_that_is_complete
    OddsAreHelpers.odds_are_with_no_winner.recipient
  end
end
