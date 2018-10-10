# The initiator's finalization and number selections of the OddsAre
class ChallengeFinalization < ApplicationRecord
  validates_presence_of :number_guessed,
                        message: "You must guess the opponent's number"

  belongs_to :odds_are
  validate :number_chosen_not_middle
  validate :number_chosen_in_bounds

  def odds_out_of
    odds_are&.odds_out_of
  end

  def number_chosen_not_middle
    if odds_out_of &&
       number_guessed &&
       odds_out_of.even? &&
       number_guessed == odds_out_of / 2

      errors.add(:number_guessed, 'Your number cannot be the middle number '\
                                 '(if this was the number, both '\
                                 'of you would lose)')
    end
  end

  def number_chosen_in_bounds
    if odds_out_of && number_guessed && number_guessed >= odds_out_of
      errors.add(:number_guessed, 'Your number must be less than what the '\
                                 'odds are out of')
    elsif number_guessed && number_guessed < 1
      errors.add(:number_guessed, 'Your number must be at least 1')
    end
  end
end
