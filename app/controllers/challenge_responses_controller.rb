require './app/services/notifications/' \
         'new_challenge_response_notification_service'
require './app/services/odds_ares/update_odds_are_with_response_service'
# Controller for handling the recipient's response of an odds are
class ChallengeResponsesController < ApplicationController
  before_action :authenticate_user!
  def create
    @challenge_response = ChallengeResponse.new(challenge_response_params)
    odds_are = OddsAre.find(@challenge_response.odds_are_id)
    if current_user == odds_are.recipient && @challenge_response.save
      UpdateOddsAreWithResponseService.new(odds_are, @challenge_response).call
      NewChallengeResponseNotificationService.new(@challenge_response).call
      redirect_to odds_ares_show_current_path(show_friends: 'active')
    elsif current_user == odds_are.recipient
      render '/challenge_requests/show'
    else
      raise Exception, 'You must be the recipient off the odds are to respond'
    end
  end

  def show
    challenge_response = ChallengeResponse.find(params[:id])
    odds_are = challenge_response.odds_are
    @challenge_action = odds_are.challenge_request.action
    @other_user = odds_are.recipient
    @response_out_of = challenge_response.odds_out_of
    @response_id = challenge_response.id

    if odds_are.initiator == current_user && odds_are.finalized_at.nil?
      @finalize_challenge = ChallengeFinalization.new(odds_are_id: odds_are.id)
    elsif odds_are.user_can_view(current_user)
      @challenge_response = challenge_response
      @odds_are = challenge_response.odds_are
      render 'odds_ares/show'
    else
      render 'pages/expired'
    end
  end

  private

  def challenge_response_params
    params.require(:challenge_response).permit(:odds_out_of,
                                               :number_chosen,
                                               :odds_are_id)
  end
end
