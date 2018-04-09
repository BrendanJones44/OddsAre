class ChallengeResponsesController < ApplicationController
  before_action :authenticate_user!
  def create
    @challenge_response = ChallengeResponse.new(challenge_response_params)
    odds_are = OddsAre.find(@challenge_response.odds_are_id)
    if current_user == odds_are.recipient
      if @challenge_response.save
        odds_are.update(responded_to_at: Time.zone.now)
        odds_are.challenge_request.notification.update(acted_upon_at: Time.zone.now)
        odds_are.challenge_response = @challenge_response
        Notification.create(
          recipient: odds_are.initiator,
          actor: current_user,
          action: "responded to your odds are",
          notifiable: @challenge_response
        )
        redirect_back(fallback_location: root_path)
      else
        render '/challenge_requests/show'
      end
    else
      raise Exception.new(
        'You must be the recipient off the odds are to respond'
      )
    end
  end

  def show
    challenge_response = ChallengeResponse.find(params[:id])
    @challenge_action = challenge_response.challenge_request.action
    @other_user = challenge_response.recipient
    @response_out_of = challenge_response.response_out_of
    @response_id = challenge_response.id
    if challenge_response.challenge_request.actor == current_user && challenge_response.finalized_at.nil?
      @finalize_challenge = FinalizeChallenge.new(challenge_response_id: challenge_response.id)
    else
      # Only set the instance variable if the user is the actor. Don't want to expose the data otherwise
      @challenge_response = challenge_response
      render 'show_as_actor'
    end
  end

  private
    def challenge_response_params
      params.require(:challenge_response).permit(:response_out_of,
                                                 :response_actor_number,
                                                 :odds_are_id)
    end
end
