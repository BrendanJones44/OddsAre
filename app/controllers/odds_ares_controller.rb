# Controller for viewing Odds Ares
class OddsAresController < ApplicationController
  before_action :authenticate_user!
  def show
    @odds_are = OddsAre.find(params.require(:id))
    if @odds_are.should_update_notification(current_user)
      @odds_are.notification.update(acted_upon_at: Time.zone.now)
    end
  end

  def show_current
    if params[:show_friends]
      @show_friends = 'active'
      @style_hide = 'display:none'
      @style_show = 'display:inline'
    end
    @requests_waiting_on_user_to_set =
      current_user.challenge_requests_waiting_on_user_to_set
    @requests_waiting_on_friends_to_set =
      current_user.challenge_requests_waiting_on_friends_to_set
    @responses_waiting_on_friends_to_complete =
      current_user.challenge_responses_waiting_on_friends_to_complete
    @responses_waiting_on_user_to_complete =
      current_user.challenge_responses_waiting_on_user_to_complete
  end

  def show_completed
    @odds_ares = current_user.completed_odds_ares
  end
end
