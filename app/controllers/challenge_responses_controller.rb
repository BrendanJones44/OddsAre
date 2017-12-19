class ChallengeResponsesController < ApplicationController
  before_action :authenticate_user!
  def create
    @challenge_request = ChallengeRequest.find(params[:challenge_request_id])
    if current_user == @challenge_request.recipient
      @challenge_response = ChallengeResponse.new(challenge_response_params)
      @challenge_response.challenge_request = @challenge_request
      if @challenge_response.save
        @challenge_request.update(responded_to_at: Time.zone.now)
        @challenge_request.notification.update(acted_upon_at: Time.zone.now)
        @challenge_request.challenge_response = @challenge_response
        Notification.create(recipient: @challenge_request.actor, actor: current_user, action: "responded to your odds are", notifiable: @challenge_response)
        redirect_to '/users/all'
      else
        render '/challenge_requests/show'
      end
    else
      render 'pages/expired'
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
      render 'show_as_actor'
    end
  end

  private
    def challenge_response_params
      params.require(:challenge_response).permit(:response_out_of, :response_actor_number, :challenge_request_id)
    end
end
