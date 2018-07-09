# The physical notification users receive associated with many different objects
class Notification < ApplicationRecord
  enum dismiss_type: [:on_click]
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :needs_action, -> { where(acted_upon_at: nil) }

  def user_can_update(user)
    recipient_id? && user == recipient
  end

  def to_s
    actor.first_name + ' ' + actor.last_name + ' ' + action
  end

  def part_of_odds_are?
    if notifiable.is_a? OddsAre
      true
    elsif notifiable.is_a? ChallengeRequest
      true
    elsif notifiable.is_a? ChallengeResponse
      true
    else
      false
    end
  end

  def odds_are
    return unless part_of_odds_are?
    if notifiable.is_a? OddsAre
      notifiable
    else
      notifiable.odds_are
    end
  end
end
