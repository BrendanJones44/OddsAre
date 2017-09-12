class ChallengeResponse < ApplicationRecord
  has_one :challenge_request
  #has_one :finalize_challenge
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  validate :response_out_of_min
  validate :response_actor_number_not_middle
  validate :response_actor_number_in_bounds

  def response_out_of_min
    if not response_out_of.blank?
      if response_out_of <= 2
        errors.add(:response_out_of, "challenge must be out of a minimum of 3")
      end
    end
  end

  def response_actor_number_not_middle
    if not response_out_of.blank?
      if response_out_of % 2 == 0
        if response_actor_number == response_out_of / 2
          errors.add(:response_actor_number, "Your number cannot be the middle number (if the challenger chooses this, both of you would lose)")
        end
      end
    end
  end

  def response_actor_number_in_bounds
    if not response_out_of.blank?
      if response_actor_number >= response_out_of
        errors.add(:response_actor_number, "Your number must be less than what the odds are out of")
      end
      if response_actor_number < 1
        errors.add(:response_actor_number, "Your number must be at least 1")
      end
    end
  end

end
