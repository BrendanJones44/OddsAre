class OddsAresController < ApplicationController
  before_action :authenticate_user!
  def show
    @odds_are = OddsAre.find((params[:id]))
    if current_user == notification.recipient && @odds_are.notification.acted_upon_at.nil?
      @odds_are.notification.update(acted_upon_at: Time.zone.now)
    end
  end
end
