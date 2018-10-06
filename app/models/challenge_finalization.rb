# The initiator's finalization and number selections of the OddsAre
class ChallengeFinalization < ApplicationRecord
  validates_presence_of :number_guessed,
                        message: "You must guess the opponent's number"
end
