class FinalizeChallengesController < ApplicationController
  before_action :authenticate_user!
  def create
    @finalize_challenge = FinalizeChallenge.new(finalize_challenge_params)

    # Find challenge response based on id number. The actual object isn't passed into
    # the finalization of the challenge for security reasons.
    @challenge_response = ChallengeResponse.find(@finalize_challenge.challenge_response_id)
    if @challenge_response.finalized_at.nil?
      if @finalize_challenge.save

        # Used for ensuring a user can't respond multiple times
        @challenge_response.update(finalized_at: Time.zone.now, acted_upon_at: Time.zone.now)

        # If nobody lost, this stays as nil
        lost_user_id = nil

        # The target of the odds are lost
        if @finalize_challenge.finalize_actor_number == @challenge_response.response_actor_number
          lost_user_id = @challenge_response.actor_id
          Task.create(lost_user_id: lost_user_id, won_user_id: current_user.id, action: @challenge_response.challenge_action)

        # The initiator of the odds are lost
        elsif @finalize_challenge.finalize_actor_number + @challenge_response.response_actor_number == @challenge_response.response_out_of
          lost_user_id = current_user.id
          Task.create(lost_user_id: lost_user_id, won_user_id: @challenge_response.actor_id, action: @challenge_response.challenge_action)
        end

        # Create a result object
        @result = ChallengeResult.create(challenge_out_of: @challenge_response.response_out_of, initiator_num: @finalize_challenge.finalize_actor_number, initiator_id: current_user.id, target_id: @challenge_response.actor_id, action: @challenge_response.challenge_action, target_num: @challenge_response.response_actor_number, lost_user_id: lost_user_id)
        if @result.save
          Notification.create(recipient: @challenge_response.actor, actor: current_user, action: "finalized an odds are challenge", notifiable: @result)
          redirect_to challenge_result_path(@result)
        else
          redirect_to '/users/all'
        end
      else
        render '/challenge_responses/show'
      end
    else
      render 'pages/expired'
    end
  end

  private
    def finalize_challenge_params
      params.require(:finalize_challenge).permit(:finalize_actor_number, :challenge_response_id)
    end
end
