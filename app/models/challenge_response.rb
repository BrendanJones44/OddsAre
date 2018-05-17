# The response from the recipient of the OddsAre
class ChallengeResponse < ApplicationRecord
  belongs_to :odds_are
  validates_presence_of :odds_out_of, message: 'You must say what the odds '\
                                               'are out of'
  validates_presence_of :number_chosen, message: 'You must pick a number'
  validate :odds_out_of_min
  validate :number_chosen_not_middle
  validate :number_chosen_in_bounds
  has_one :notification, as: :notifiable

  def odds_out_of_min
    unless odds_out_of.blank?
      errors.add(:odds_out_of, 'Odds are must be out of a minimum of 3') if
       odds_out_of <= 2
     end
  end

  def number_chosen_not_middle
    if !odds_out_of.blank? && !number_chosen.blank?
      if odds_out_of.even?
        if number_chosen == odds_out_of / 2
          errors.add(:number_chosen, 'Your number cannot be the middle number '\
                                     '(if the challenger chooses this, both '\
                                     'of you would lose)')
        end
      end
    end
  end

  def number_chosen_in_bounds
    if !odds_out_of.blank? && !number_chosen.blank?
      if number_chosen >= odds_out_of
        errors.add(:number_chosen, 'Your number must be less than what the '\
                                   'odds are out of')
      end
      if number_chosen < 1
        errors.add(:number_chosen, 'Your number must be at least 1')
      end
    end
  end
end
