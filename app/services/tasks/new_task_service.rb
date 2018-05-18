# Create and return a Task based on the results of an Odds Are.
# This will return nil if nobody wins
class NewTaskService
  def initialize(odds_are)
    @odds_are = odds_are
  end

  def call
    if @odds_are.recipient_won
      Task.create(loser: @odds_are.initiator,
                  winner: @odds_are.recipient,
                  action: @odds_are.challenge_request.action)
    elsif @odds_are.initiator_won
      Task.create(loser: @odds_are.recipient,
                  winner: @odds_are.initiator,
                  action: @odds_are.challenge_request.action)
    end
  end
end
