class ChallengeFinalizationsController < ApplicationController
  before_action :authenticate_user!

  def create
    params.require(:challenge_finalization)
    @finalize_challenge = ChallengeFinalization.new(finalize_challenge_params)
    odds_are = OddsAre.find(@finalize_challenge.odds_are_id)
    if odds_are.finalized_at?
      raise Exception.new(
        "This odds are has already been completed"
      )
    end
    if odds_are.initiator != current_user
      raise Exception.new(
        'You must be the initiator of the odds are to respond')
    else
    end
    # if challenge_response.finalized_at.nil?
    #   @finalize_challenge = FinalizeChallenge.new(finalize_challenge_params)
    #   if @finalize_challenge.save
    #
    #     # Used for ensuring a user can't respond multiple times
    #     challenge_response.update(finalized_at: Time.zone.now)
    #     challenge_response.notification.update(acted_upon_at: Time.zone.now)
    #     # If nobody loses, these stay nil
    #     lost_user_id = nil
    #     won_user_id = nil
    #
    #     # The target of the odds are lost
    #     if @finalize_challenge.finalize_actor_number == challenge_response.response_actor_number
    #       lost_user_id = challenge_response.challenge_request.recipient.id
    #       won_user_id = current_user.id
    #       Task.create(lost_user_id: lost_user_id, won_user_id: current_user.id, action: challenge_response.challenge_request.action)
    #
    #     # The initiator of the odds are lost
    #     elsif @finalize_challenge.finalize_actor_number + challenge_response.response_actor_number == challenge_response.response_out_of
    #       lost_user_id = current_user.id
    #       won_user_id = challenge_response.challenge_request.recipient_id
    #       Task.create(lost_user_id: lost_user_id, won_user_id: challenge_response.actor_id, action: challenge_response.challenge_action)
    #     end
    #
    #     # Create a result object
    #     @result = ChallengeResult.create(challenge_out_of: challenge_response.response_out_of,
    #                                        initiator_num: @finalize_challenge.finalize_actor_number,
    #                                        initiator_id: current_user.id,
    #                                        target_id: challenge_response.challenge_request.recipient_id,
    #                                        action: challenge_response.challenge_request.action,
    #                                        target_num: challenge_response.response_actor_number,
    #                                        lost_user_id: lost_user_id,
    #                                        won_user_id: won_user_id)
    #     if @result.save
    #       Notification.create(recipient: challenge_response.challenge_request.recipient , actor: current_user, action: "completed an odds are", notifiable: @result)
    #       redirect_to challenge_result_path(@result)
    #     else
    #       redirect_to '/users/all'
    #     end
    #   else
    #     render '/challenge_responses/show'
    #   end
    # else
    #   render 'pages/expired'
    # end
  end

  private
    def finalize_challenge_params
      params.require(:challenge_finalization).permit(:number_guessed, :odds_are_id)
    end
end
