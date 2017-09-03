class ChallengeResultsController < ApplicationController
  def show
    @result = ChallengeResult.find((params[:id]))
  end
end
