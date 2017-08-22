class ChallengeRequestsController < ApplicationController
  def new
    @friends = current_user.friends
    @challenge_request = ChallengeRequest.new
  end

  def create
    @challenge_request = ChallengeRequest.new(challenge_params)
		@challenge_request.actor = current_user

		if @challenge_request.save
      Notification.create(recipient: @challenge_request.recipient, actor: current_user, action: "sent you and odds are challenge", notifiable: @challenge_request)
			redirect_to '/users/all'
		else
			@friends = current_user.friends
			render 'new'
		end
  end

  def show
    @challenge_request = ChallengeRequest.find((params[:id]))
    @challenge_response = ChallengeResponse.new(challenge_request: @challenge_request)
  end
  private
		def challenge_params
			params.require(:challenge_request).permit(:action, :recipient_id)
		end

end
