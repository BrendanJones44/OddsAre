class FinalizeChallengesController < ApplicationController
  def create
    @finalize_challenge = FinalizeChallenge.new(finalize_challenge_params)
    @challenge_response = ChallengeResponse.find(params[:challenge_response_id])
    #@finalize_challenge.challenge_response_id = @challenge_response.id



#
#t.integer  "initiator_id"
#t.integer  "target_id"
#t.integer  "target_num"
    if @finalize_challenge.save
      @challenge_response.update(finalized_at: Time.zone.now)
      lost_user_id = nil
      if @finalize_challenge.finalize_actor_number == @challenge_response.response_actor_number
        lost_user_id = @challenge_response.actor_id
      elsif @finalize_challenge.finalize_actor_number + @challenge_response.response_actor_number == @challenge_response.response_out_of
        lost_user_id = current_user.id
      end
      @result = ChallengeResult.create(challenge_out_of: @challenge_response.response_out_of, initiator_num: @finalize_challenge.finalize_actor_number, initiator_id: current_user.id, target_id: @challenge_response.actor_id, action: @challenge_response.challenge_action, target_num: @challenge_response.response_actor_number, lost_user_id: lost_user_id)
      if @result.save


        Notification.create(recipient: @challenge_response.actor, actor: current_user, action: "finalized an odds are challenge", notifiable: @result)
        redirect_to challenge_result_path(@result)
      else
        redirect_to '/users/all'
      end
    else
      render '/challenge_response/show'
    end
  end

  private
    def finalize_challenge_params
      params.require(:finalize_challenge).permit(:finalize_actor_number, :challenge_response_id)
    end
end
