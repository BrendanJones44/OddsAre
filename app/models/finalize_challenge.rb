class FinalizeChallenge < ApplicationRecord
    validates_presence_of :finalize_actor_number, :message => 'You must repsond with a number'
    validate :finalize_actor_number_min
    def finalize_actor_number_min
      if not finalize_actor_number.blank?
        if finalize_actor_number < 1
          errors.add(:finalize_actor_number, "Your number must be at least 1")
        end
      end
    end
end
