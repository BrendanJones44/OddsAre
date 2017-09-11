class ChallengeResponsesController < ApplicationController
  before_action :authenticate_user!
  def create
    @challenge_request = ChallengeRequest.find(params[:challenge_request_id])
    if current_user == @challenge_request.recipient
      @challenge_response = ChallengeResponse.new(challenge_response_params)
      @challenge_response.challenge_request_id = params[:challenge_request_id]
      @challenge_response.challenge_action = @challenge_request.action
      @challenge_response.actor = current_user
      @challenge_response.recipient = @challenge_request.actor

      if @challenge_response.save
        #@challenge_request.update(acted_upon_at: Time.zone.now)
        @challenge_request.update(responded_to_at: Time.zone.now, acted_upon_at: Time.zone.now)

        Notification.create(recipient: @challenge_request.actor, actor: current_user, action: "responded to your odds are challenge", notifiable: @challenge_response)
        redirect_to '/users/all'
      else
        render '/challenge_requests/show'
      end
    else
      render 'pages/expired'
    end
  end

  def show
    @challenge_response = ChallengeResponse.select("response_out_of, challenge_action, id, recipient_id, actor_id, finalized_at").where(:id => params[:id]).first
    if @challenge_response.recipient == current_user && @challenge_response.finalized_at.nil?
      @finalize_challenge = FinalizeChallenge.new()
    else
      render 'show_as_actor'
    end
  end

  private
    def challenge_response_params
      params.require(:challenge_response).permit(:response_out_of, :response_actor_number, :challenge_request_id, :challenge_action)
    end
end
