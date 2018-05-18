require './app/services/notifications/' \
        'new_challenge_finalization_notification_service'
require './app/services/tasks/new_task_service'
require './app/services/odds_ares/update_odds_are_with_finalization_service'
# Controller for handling the finalization of the Odds Are by the initiator
class ChallengeFinalizationsController < ApplicationController
  before_action :authenticate_user!

  def create
    params.require(:challenge_finalization)
    @challenge_finalization = ChallengeFinalization
                              .new(finalize_challenge_params)
    odds_are = OddsAre.find(@challenge_finalization.odds_are_id)
    if odds_are.finalized_at?
      raise Exception, 'This odds are has already been completed'
    end
    if odds_are.initiator != current_user
      raise Exception, 'You must be the initiator of the odds are to respond'
    else
      @challenge_finalization = ChallengeFinalization
                                .new(finalize_challenge_params)

      if @challenge_finalization.save
        task = NewTaskService.new(odds_are).call
        UpdateOddsAreWithFinalizationService.new(odds_are, task).call
        NewChallengeFinalizationNotificationService.new(odds_are).call
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
