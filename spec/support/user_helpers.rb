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
    get_user_with_complete_odds_are_where_nobody_wins_as_initiator(true)
  end

  def get_user_with_complete_odds_are_where_nobody_wins_as_initiator(initiator)
    user_a = FactoryGirl.create :user
    user_b = FactoryGirl.create :user

    user_a.friend_request(user_b)
    user_b.accept_request(user_a)

    challenge_request = FactoryGirl.create(:challenge_request)

    challenge_response = FactoryGirl.create(:challenge_response,
                                            :odds_are_id => 1,
                                            :number_chosen => 10,
                                            :odds_out_of => 50)

    challenge_finalization = FactoryGirl.create(:challenge_finalization,
                                                :odds_are_id => 1,
                                                :number_guessed => 2)

    odds_are = FactoryGirl.create(:odds_are,
                                  :initiator => user_a,
                                  :recipient => user_b,
                                  :challenge_request => challenge_request,
                                  :challenge_response => challenge_response,
                                  :responded_to_at => Time.zone.now,
                                  :challenge_finalization =>
                                    challenge_finalization,
                                  :finalized_at => Time.zone.now )

    if initiator
      user_a
    else
      user_b
    end
  end

  def get_user_with_unresponded_odds_are
    get_user_with_unresponded_odds_are_as_initiator(true)
  end

  def get_user_with_unresponded_odds_are_as_initiator(initiator)
    user_a = FactoryGirl.create :user
    user_b = FactoryGirl.create :user

    user_a.friend_request(user_b)
    user_b.accept_request(user_a)

    challenge_request = FactoryGirl.create(:challenge_request)
    odds_are = FactoryGirl.create(:odds_are,
                                  :initiator => user_a,
                                  :recipient => user_b,
                                  :challenge_request => challenge_request)

    if initiator
      user_a
    else
      user_b
    end
  end

  def get_user_with_unfinalized_odds_are
    get_user_with_unfinalized_odds_are_as_initiator(true)
  end


  def get_user_with_unfinalized_odds_are_as_initiator(initiator)
    user_a = FactoryGirl.create :user
    user_b = FactoryGirl.create :user

    user_a.friend_request(user_b)
    user_b.accept_request(user_a)

    challenge_request = FactoryGirl.create(:challenge_request)

    challenge_response = FactoryGirl.create(:challenge_response,
                                            :odds_are_id => 1,
                                            :number_chosen => 10,
                                            :odds_out_of => 50)

    odds_are = FactoryGirl.create(:odds_are,
                                  :initiator => user_a,
                                  :recipient => user_b,
                                  :challenge_request => challenge_request,
                                  :challenge_response => challenge_response,
                                  :responded_to_at => Time.zone.now)
    if initiator
      user_a
    else
      user_b
    end
  end

  def get_user_with_complete_odds_are_with_winner(winner)
    user_a = FactoryGirl.create :user
    user_b = FactoryGirl.create :user

    user_a.friend_request(user_b)
    user_b.accept_request(user_a)

    challenge_request = FactoryGirl.create(:challenge_request)

    challenge_response = FactoryGirl.create(:challenge_response,
                                            :odds_are_id => 1,
                                            :number_chosen => 10,
                                            :odds_out_of => 50)

    challenge_finalization = FactoryGirl.create(:challenge_finalization,
                                                :odds_are_id => 1,
                                                :number_guessed => 40)

    task = FactoryGirl.create(:task,
                              :winner => user_b,
                              :loser => user_a)

    odds_are = FactoryGirl.create(:odds_are,
                                  :initiator => user_a,
                                  :recipient => user_b,
                                  :challenge_request => challenge_request,
                                  :challenge_response => challenge_response,
                                  :responded_to_at => Time.zone.now,
                                  :challenge_finalization =>
                                    challenge_finalization,
                                  :finalized_at => Time.zone.now,
                                  :task => task)

    if winner
      user_b
    else
      user_a
    end
  end

  def get_user_with_won_odds_are
    get_user_with_complete_odds_are_with_winner(true)
  end

  def get_user_with_lost_odds_are
    get_user_with_complete_odds_are_with_winner(false)
  end

  def get_user_initiating_odds_are_with_no_response
    get_user_with_unresponded_odds_are_as_initiator(true)
  end

  def get_user_initiating_odds_are_with_no_finalization
    get_user_with_unfinalized_odds_are_as_initiator(true)
  end

  def get_user_initiating_odds_are_that_is_complete
    get_user_with_complete_odds_are_where_nobody_wins_as_initiator(true)
  end

  def get_user_receiving_odds_are_with_no_response
    get_user_with_unresponded_odds_are_as_initiator(false)
  end

  def get_user_receiving_odds_are_with_no_finalization
    get_user_with_unfinalized_odds_are_as_initiator(false)
  end

  def get_user_receiving_odds_are_that_is_complete
    get_user_with_complete_odds_are_where_nobody_wins_as_initiator(false)
  end


end
