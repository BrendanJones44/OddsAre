class OddsAresController < ApplicationController
  before_action :authenticate_user!
  def show
    @odds_are = OddsAre.find((params[:id]))
    if current_user == notification.recipient && @odds_are.notification.acted_upon_at.nil?
      @odds_are.notification.update(acted_upon_at: Time.zone.now)
    end
  end

  def show_current
    if(params[:show_friends])
      @show_friends = "active"
      @style_hide = "display:none"
      @style_show = "display:inline"
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
end
