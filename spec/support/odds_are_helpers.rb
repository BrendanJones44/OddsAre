module OddsAreHelpers
  def odds_are_with_no_response
    user_a = FactoryGirl.create :user
    user_b = FactoryGirl.create :user

    user_a.friend_request(user_b)
    user_b.accept_request(user_a)

    challenge_request = FactoryGirl.create(:challenge_request)
    FactoryGirl.create(:odds_are,
                       initiator: user_a,
                       recipient: user_b,
                       challenge_request: challenge_request)
  end

  def odds_are_with_no_finalization
    user_a = FactoryGirl.create :user
    user_b = FactoryGirl.create :user

    user_a.friend_request(user_b)
    user_b.accept_request(user_a)

    challenge_request = FactoryGirl.create(:challenge_request)

    challenge_response = FactoryGirl.create(:challenge_response,
                                            odds_are_id: 1,
                                            number_chosen: 10,
                                            odds_out_of: 50)

    FactoryGirl.create(:odds_are,
                       initiator: user_a,
                       recipient: user_b,
                       challenge_request: challenge_request,
                       challenge_response: challenge_response,
                       responded_to_at: Time.zone.now)
  end

  def odds_are_with_winner
    user_a = FactoryGirl.create :user
    user_b = FactoryGirl.create :user

    user_a.friend_request(user_b)
    user_b.accept_request(user_a)

    challenge_request = FactoryGirl.create(:challenge_request)

    challenge_response = FactoryGirl.create(:challenge_response,
                                            odds_are_id: 1,
                                            number_chosen: 10,
                                            odds_out_of: 50)

    challenge_finalization = FactoryGirl.create(:challenge_finalization,
                                                odds_are_id: 1,
                                                number_guessed: 40)

    task = FactoryGirl.create(:task,
                              winner: user_b,
                              loser: user_a)

    FactoryGirl.create(:odds_are,
                       initiator: user_a,
                       recipient: user_b,
                       challenge_request: challenge_request,
                       challenge_response: challenge_response,
                       responded_to_at: Time.zone.now,
                       challenge_finalization: challenge_finalization,
                       finalized_at: Time.zone.now,
                       task: task)
  end

  def odds_are_with_no_winner
    user_a = FactoryGirl.create :user
    user_b = FactoryGirl.create :user

    user_a.friend_request(user_b)
    user_b.accept_request(user_a)

    challenge_request = FactoryGirl.create(:challenge_request)

    challenge_response = FactoryGirl.create(:challenge_response,
                                            odds_are_id: 1,
                                            number_chosen: 10,
                                            odds_out_of: 50)

    challenge_finalization = FactoryGirl.create(:challenge_finalization,
                                                odds_are_id: 1,
                                                number_guessed: 2)

    FactoryGirl.create(:odds_are,
                       initiator: user_a,
                       recipient: user_b,
                       challenge_request: challenge_request,
                       challenge_response: challenge_response,
                       responded_to_at: Time.zone.now,
                       challenge_finalization: challenge_finalization,
                       finalized_at: Time.zone.now)
  end
  module_function :odds_are_with_no_response
  module_function :odds_are_with_no_finalization
  module_function :odds_are_with_winner
  module_function :odds_are_with_no_winner
end
