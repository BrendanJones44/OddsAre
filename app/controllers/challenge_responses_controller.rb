class ChallengeResponsesController < ApplicationController
  def create
    @challenge_response = ChallengeResponse.new(challenge_response_params)
    @challenge_request = ChallengeRequest.find(params[:challenge_request_id])
    if @challenge_response.save
      Notification.create(recipient: @challenge_request.actor, actor: current_user, action: "responded to your odds are challenge", notifiable: @challenge_response)
      redirect_to '/users/all'
    else
      render '/challenge_requests/show'
    end
  end

  def show
    @challenge_response = ChallengeResponse.select("response_out_of").where(:id => params[:id])
  end

  private
    def challenge_response_params
      params.require(:challenge_response).permit(:response_out_of, :response_actor_number, :challenge_request_id)
    end
end
