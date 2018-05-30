require './app/services/notifications/' \
        'new_challenge_finalization_notification_service'
require './app/services/tasks/new_task_service'
require './app/services/odds_ares/update_odds_are_with_finalization_service'
# Controller for handling the finalization of the Odds Are by the initiator
class ChallengeFinalizationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @challenge_finalization = ChallengeFinalization
                              .new(finalize_challenge_params)
    odds_are = OddsAre.find(@challenge_finalization.odds_are_id)
    if odds_are.should_finalize(current_user) && @challenge_finalization.save
      task = NewTaskService.new(odds_are).call
      UpdateOddsAreWithFinalizationService.new(odds_are, task).call
      NewChallengeFinalizationNotificationService.new(odds_are).call
      redirect_to odds_are
    elsif !odds_are.should_finalize(current_user)
      return render '/pages/expired'
    end
  end

  private

  def finalize_challenge_params
    params.require(:challenge_finalization).permit(:number_guessed,
                                                   :odds_are_id)
  end
end
