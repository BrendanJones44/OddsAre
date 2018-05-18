# Create a Notification from a Challenge Response being initialized by a user
class NewChallengeResponseNotificationService
  def initialize(challenge_response)
    @challenge_response = challenge_response
  end

  def call
    Notification.create(recipient: @challenge_response.odds_are.initiator,
                        actor: @challenge_response.odds_are.recipient,
                        action: 'sent you an odds are',
                        notifiable: @challenge_response)
  end
end
