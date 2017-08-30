class ChallengeResultsController < ApplicationController
  def show
    @result = ChallengeResult.find(1)
  end
end
