# Set the instance fields for the challenge response form based on the state
# of the odds are
class SetChallengeResponseFieldsService
  attr_accessor :finalize_challenge,
                :challenge_action,
                :other_user,
                :response_out_of,
                :response_id,
                :odds_are
  def initialize(odds_are, user)
    @user = user
    @finalize_challenge = ChallengeFinalization.new(odds_are_id: odds_are.id)
    @challenge_action = odds_are.challenge_request.action
    @other_user = odds_are.recipient
    @response_out_of = odds_are.challenge_response.odds_out_of
    @response_id = odds_are.challenge_response.id
    @odds_are = odds_are
  end
end
