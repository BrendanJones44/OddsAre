require './app/services/notifications/' \
         'new_challenge_response_notification_service'
require './app/services/odds_ares/update_odds_are_with_response_service'
require './app/services/challenge_responses/' \
         'set_challenge_response_fields_service'
# Controller for handling the recipient's response of an odds are
class ChallengeResponsesController < ApplicationController
  before_action :authenticate_user!
  def create
    @challenge_response = ChallengeResponse.new(challenge_response_params)
    odds_are = OddsAre.find(@challenge_response.odds_are_id)
    if current_user == odds_are.recipient && @challenge_response.save
      UpdateOddsAreWithResponseService.new(odds_are, @challenge_response).call
      NewChallengeResponseNotificationService.new(@challenge_response).call
      redirect_to odds_are
    elsif current_user == odds_are.recipient
      render '/challenge_requests/show'
    else
      raise Exception, 'You must be the recipient off the odds are to respond'
    end
  end

  def show
    challenge_response = ChallengeResponse.find(params[:id])
    odds_are = challenge_response.odds_are
    @challenge_response_fields = SetChallengeResponseFieldsService
                                 .new(odds_are, current_user)

    return render '/odds_ares/show' if odds_are.user_can_view(current_user)
    return render '/pages/expired' unless odds_are.should_finalize(current_user)
    render '/challenge_responses/show'
  end

  private

  def challenge_response_params
    params.require(:challenge_response).permit(:odds_out_of,
                                               :number_chosen,
                                               :odds_are_id)
  end
end
