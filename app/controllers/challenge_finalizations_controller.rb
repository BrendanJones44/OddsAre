class ChallengeFinalizationsController < ApplicationController
  before_action :authenticate_user!

  def create
    params.require(:challenge_finalization)
    @challenge_finalization = ChallengeFinalization.new(finalize_challenge_params)
    odds_are = OddsAre.find(@challenge_finalization.odds_are_id)
    if odds_are.finalized_at?
      raise Exception, 'This odds are has already been completed'
    end
    if odds_are.initiator != current_user
      raise Exception, 'You must be the initiator of the odds are to respond'
    else
      @challenge_finalization = ChallengeFinalization.new(finalize_challenge_params)

      if @challenge_finalization.save

        challenge_response = odds_are.challenge_response

        if odds_are.recipient_won
          task = Task.create(loser: odds_are.initiator,
                             winner: odds_are.recipient,
                             action: odds_are.challenge_request.action)
          odds_are.update(task: task)
        elsif odds_are.initiator_won
          task = Task.create(loser: odds_are.recipient,
                             winner: odds_are.initiator,
                             action: odds_are.challenge_request.action)
          odds_are.update(task: task)
        end

        odds_are.update(finalized_at: Time.zone.now)
        odds_are.challenge_response.notification
                .update(acted_upon_at: Time.zone.now)
        Notification.create(recipient: odds_are.recipient,
                            actor: current_user,
                            action: 'completed an odds are',
                            notifiable: odds_are)
        redirect_back(fallback_location: root_path)
      end
    end
  end

  private

  def finalize_challenge_params
    params.require(:challenge_finalization).permit(:number_guessed,
                                                   :odds_are_id)
  end
end
