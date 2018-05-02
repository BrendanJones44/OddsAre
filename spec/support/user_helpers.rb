require_relative './odds_are_helpers'

module UserHelpers
  def get_user_with_friends
    user_a = FactoryGirl.create :user
    user_b = FactoryGirl.create :user
    user_a.friend_request(user_b)
    user_b.accept_request(user_a)
    user_a
  end

  def get_user_with_friend_request
    user_a = FactoryGirl.create :user
    user_b = FactoryGirl.create :user
    user_a.friend_request(user_b)
    user_b
  end

  def get_user_with_complete_odds_are_where_nobody_wins
    OddsAreHelpers.get_odds_are_with_no_winner.initiator
  end

  def get_user_with_unresponded_odds_are
    OddsAreHelpers.get_odds_are_with_no_response.initiator
  end

  def get_user_with_unfinalized_odds_are
    OddsAreHelpers.get_odds_are_with_no_finalization.initiator
  end

  def get_user_with_won_odds_are
    OddsAreHelpers.get_odds_are_with_winner.task.winner
  end

  def get_user_with_lost_odds_are
    OddsAreHelpers.get_odds_are_with_winner.task.loser
  end

  def get_user_initiating_odds_are_with_no_response
    OddsAreHelpers.get_odds_are_with_no_response.initiator
  end

  def get_user_initiating_odds_are_with_no_finalization
    OddsAreHelpers.get_odds_are_with_no_finalization.initiator
  end

  def get_user_initiating_odds_are_that_is_complete
    OddsAreHelpers.get_odds_are_with_no_winner.initiator
  end

  def get_user_receiving_odds_are_with_no_response
    OddsAreHelpers.get_odds_are_with_no_response.recipient
    get_user_with_unresponded_odds_are_as_initiator(false)
  end

  def get_user_receiving_odds_are_with_no_finalization
    OddsAreHelpers.get_odds_are_with_no_finalization.recipient
    get_user_with_unfinalized_odds_are_as_initiator(false)
  end

  def get_user_receiving_odds_are_that_is_complete
    OddsAreHelpers.get_odds_are_with_no_winner.recipient
  end
end
