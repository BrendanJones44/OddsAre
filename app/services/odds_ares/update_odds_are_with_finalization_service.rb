# Update an Odds Are after it's been finalized
class UpdateOddsAreWithFinalizationService
  def initialize(odds_are, task)
    @odds_are = odds_are
    @task = task
  end

  def call
    @odds_are.update(task: @task)
    @odds_are.update(finalized_at: Time.zone.now)
    @odds_are.challenge_response.notification
             .update(acted_upon_at: Time.zone.now)
  end
end
