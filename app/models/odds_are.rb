class OddsAre < ApplicationRecord
  ### Associations ###
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :initiator, class_name: 'User', foreign_key: 'initiator_id'
  has_one :challenge_request
  has_one :challenge_response
  has_one :challenge_finalization
  has_one :task
  has_one :notification, as: :notifiable

  ### Helper methods ###
  def user_can_view(user)
    (recipient == user || initiator == user) && \
      finalized_at?
  end

  def initiator_won
    if challenge_response && challenge_finalization
      challenge_response.number_chosen == \
        challenge_finalization.number_guessed
    else
      false
    end
  end

  def recipient_won
    if challenge_response && challenge_finalization
      challenge_finalization.number_guessed + \
        challenge_response.number_chosen == \
        challenge_response.odds_out_of
    else
      false
    end
  end

  def should_update_notification(user)
    if notification
      notification.recipient == user && \
        notification.acted_upon_at.nil?
    else
      false
    end
  end
end
