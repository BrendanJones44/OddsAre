# Update an Odds Are after it's been responded to by a Challenge Response
class UpdateOddsAreWithResponseService
  def initialize(odds_are, challenge_response)
    @odds_are = odds_are
    @challenge_response = challenge_response
  end

  def call
    @odds_are.update(responded_to_at: Time.zone.now)
    @odds_are.challenge_request.notification
             .update(acted_upon_at: Time.zone.now)
    @odds_are.update(challenge_response: @challenge_response)
  end
end
