class FinalizeChallenge < ApplicationRecord
    #elongs_to :challenge_response
    has_one :notification, as: :notifiable 
    validates_presence_of :finalize_actor_number, :message => 'You must repsond with a number'
    validates_presence_of :challenge_response_id, :message => 'No id found'
    validate :finalize_actor_number_min
    validate :finalize_actor_number_max
    def finalize_actor_number_min
      if not finalize_actor_number.blank?
        if finalize_actor_number < 1
          errors.add(:finalize_actor_number, "Your number must be at least 1")
        end
      end
    end
    def finalize_actor_number_max
      if not finalize_actor_number.blank?
        if finalize_actor_number >= ChallengeResponse.find(challenge_response_id).response_out_of
          errors.add(:finalize_actor_number, "Your number must be at maximum 1 less than what the odds are out of")
        end
      end
    end

end
