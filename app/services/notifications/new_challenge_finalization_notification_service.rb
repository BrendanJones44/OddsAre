# Create a Notification from an Odds Are being finalized by a user
class NewChallengeFinalizationNotificationService
  def initialize(odds_are)
    @odds_are = odds_are
  end

  def call
    Notification.create(recipient: @odds_are.recipient,
                        actor: @odds_are.initiator,
                        action: 'completed an odds are',
                        notifiable: @odds_are)
  end
end
