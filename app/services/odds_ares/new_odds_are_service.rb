# Create Odds Ares from a Challenge Request being initialized by a user
class NewOddsAreService
  def initialize(challenge_request, initiator, recipient)
    @challenge_request = challenge_request
    @initiator = initiator
    @recipient = recipient
  end

  def call
    OddsAre.create(initiator: @initiator,
                   challenge_request: @challenge_request,
                   recipient: @recipient)
  end
end
