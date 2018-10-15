# The action that must be performed by the result of a lost OddsAre
class Task < ApplicationRecord
  belongs_to :winner, class_name: 'User', foreign_key: 'winner_id'
  belongs_to :loser, class_name: 'User', foreign_key: 'loser_id'
  belongs_to :odds_are

  def can_user_update_as_loser?(user)
    user == loser && loser_marked_completed_at.nil?
  end

  def can_user_update_as_winner?(user)
    user == winner && winner_marked_completed_at.nil?
  end

  def both_marked_complete?
    loser_marked_completed_at.present? && winner_marked_completed_at.present?
  end
end
