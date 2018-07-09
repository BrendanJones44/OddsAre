require_relative './odds_are_helpers'

# Collection of helper methods to get various instances of a notification
# Each instance has a slightly modified state/association
module NotificationHelpers
  def notification_from_receiving_friend_request
    initiator = FactoryGirl.create :user
    recipient = FactoryGirl.create :user

    initiator.friend_request(recipient)

    FactoryGirl.create(:notification,
                       recipient: recipient,
                       actor: initiator,
                       action: 'sent you a friend request',
                       acted_upon_at: nil)
  end

  def notification_from_accepting_friend_request
    recipient = FactoryGirl.create :user
    initiator = FactoryGirl.create :user

    recipient.friend_request(initiator)
    initiator.accept_request(recipient)

    FactoryGirl.create(:notification,
                       recipient: recipient,
                       actor: initiator,
                       action: 'accepted your friend request',
                       acted_upon_at: nil)

  end

  def notification_from_initiating_odds_are
    odds_are = OddsAreHelpers.odds_are_with_no_response
    
    FactoryGirl.create(:notification,
                       recipient: odds_are.recipient,
                       actor: odds_are.initiator,
                       action: 'sent you an odds are',
                       notifiable: odds_are.challenge_request)
  end

  def notification_from_responding_odds_are
    odds_are = OddsAreHelpers.odds_are_with_no_finalization

    FactoryGirl.create(:notification,
                       recipient: odds_are.initiator,
                       actor: odds_are.recipient,
                       action: 'responded to your odds are',
                       notifiable: odds_are.challenge_response)

  end

  def notification_from_finalizing_odds_are
    odds_are = OddsAreHelpers.odds_are_with_no_winner

    FactoryGirl.create(:notification,
                       recipient: odds_are.recipient,
                       actor: odds_are.initiator,
                       action: 'completed an odds are',
                       notifiable: odds_are)
  end

end