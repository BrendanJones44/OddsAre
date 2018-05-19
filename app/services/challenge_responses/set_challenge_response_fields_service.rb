# Set the instance fields for the challenge response form based on the state
# of the odds are
class SetChallengeResponseFieldsService
  def initialize(odds_are, user)
    @odds_are = odds_are
    @user = user
  end

  def call
    if @odds_are.should_finalize(@user)
      @finalize_challenge = ChallengeFinalization.new(odds_are_id: @odds_are.id)
      @challenge_action = @odds_are.challenge_request.action
      @other_user = @odds_are.recipient
      @response_out_of = @odds_are.challenge_response.odds_out_of
      @response_id = @odds_are.challenge_response.id
    elsif @odds_are.user_can_view(@user)
      @challenge_response = @odds_are.challenge_response
    end
  end
end
