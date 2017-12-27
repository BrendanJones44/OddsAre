class ChallengeRequestsController < ApplicationController
  before_action :authenticate_user!
  def new
    @friends = current_user.friends
    if @friends.length == 0
      @action = "send an odds are"
      render 'pages/need_friends'
    else
      @challenge_request = ChallengeRequest.new
    end
  end

  def create
    @challenge_request = ChallengeRequest.new(challenge_params)
		@challenge_request.actor = current_user

		if @challenge_request.save
      Notification.create(recipient: @challenge_request.recipient, actor: current_user, action: "sent you an odds are", notifiable: @challenge_request)
      redirect_back(fallback_location: root_path)
		else
			@friends = current_user.friends
			render 'new'
		end
  end

  def show
    @challenge_request = ChallengeRequest.find((params[:id]))
    if @challenge_request.responded_to_at.nil? && @challenge_request.recipient == current_user
      @challenge_response = ChallengeResponse.new(challenge_request: @challenge_request)
    elsif @challenge_request.actor == current_user
      render 'show_as_actor'
    else
      render 'pages/expired'
    end
  end

  def show_current
    @requests_waiting_on_user_to_set = current_user.challenge_requests_waiting_on_user_to_set
    @requests_waiting_on_friends_to_set = current_user.challenge_requests_waiting_on_friends_to_set
    @responses_waiting_on_friends_to_complete = current_user.challenge_responses_waiting_on_friends_to_complete
    @responses_waiting_on_user_to_complete = current_user.challenge_responses_waiting_on_user_to_complete
  end
  private
		def challenge_params
			params.require(:challenge_request).permit(:action, :recipient_id)
		end

end
