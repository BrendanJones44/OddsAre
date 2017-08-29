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
    if @challenge_request.responded_to_at.nil? && @challenge_request.recipient == current_user
    #Eventually add logic. Challenge requests should have a responded to timestamp that gets updated. Then
    #only challenge requests that haven't been responded to are sent.
      @challenge_response = ChallengeResponse.new(challenge_request: @challenge_request)
    elsif @challenge_request.actor == current_user
      render 'show_as_actor'
    else
      render 'pages/expired'
    end

  end
  private
		def challenge_params
			params.require(:challenge_request).permit(:action, :recipient_id)
		end

end
