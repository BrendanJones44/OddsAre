class ChallengeResultsController < ApplicationController
  before_action :authenticate_user!
  def show
    @result = ChallengeResult.find((params[:id]))
    if @result.acted_upon_at.nil?
      @result.update(acted_upon_at: Time.zone.now)
    end
  end
end
