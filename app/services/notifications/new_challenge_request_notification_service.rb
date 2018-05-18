# Create a Notification from a Challenge Request being initialized by a user
class NewChallengeRequestNotificationService
  def initialize(challenge_request)
    @challenge_request = challenge_request
  end

  def call
    Notification.create(recipient: @challenge_request.odds_are.recipient,
                        actor: @challenge_request.odds_are.initiator,
                        action: 'sent you an odds are',
                        notifiable: @challenge_request)
  end
end
