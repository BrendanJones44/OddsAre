class FinalizeChallengesController < ApplicationController
  def create
    @finalize_challenge = FinalizeChallenge.new(finalize_challenge_params)
    @challenge_response = ChallengeRequest.find(params[:challenge_response_id])
    @finalize_challenge.challenge_response_id = @challenge_response.id

    if @finalize_challenge.save
      redirect_to '/users/all'
    else
      render '/challenge_response/show'
    end
  end

  private
    def finalize_challenge_params
      params.require(:finalize_challenge).permit(:finalize_actor_number, :challenge_response_id)
    end
end
