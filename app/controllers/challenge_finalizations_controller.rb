require './app/services/notifications/' \
        'new_challenge_finalization_notification_service'
require './app/services/tasks/new_task_service'
require './app/services/odds_ares/update_odds_are_with_finalization_service'
require './app/services/challenge_responses/' \
         'set_challenge_response_fields_service'
# Controller for handling the finalization of the Odds Are by the initiator
class ChallengeFinalizationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @challenge_finalization = ChallengeFinalization
                              .new(finalize_challenge_params)
    odds_are = OddsAre.find(@challenge_finalization.odds_are_id)
    if odds_are.should_finalize(current_user) && @challenge_finalization.save
      NewChallengeFinalizationNotificationService.new(odds_are).call
      UpdateOddsAreWithFinalizationService.new(odds_are).call
      task = NewTaskService.new(odds_are).call
      odds_are.update(task: task)
      redirect_to odds_are
    elsif !odds_are.should_finalize(current_user)
      return render '/pages/expired'
    else
      @challenge_response_fields = SetChallengeResponseFieldsService
                                  .new(odds_are, current_user)

      return render '/odds_ares/show' if odds_are.user_can_view(current_user)
      return render '/pages/expired' unless odds_are.should_finalize(current_user)
      render '/challenge_responses/show'
    end
  end

  private

  def finalize_challenge_params
    params.require(:challenge_finalization).permit(:number_guessed,
                                                   :odds_are_id)
  end
end
