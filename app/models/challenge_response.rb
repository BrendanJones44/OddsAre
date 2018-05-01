class ChallengeResponse < ApplicationRecord
    belongs_to :odds_are
  # belongs_to :challenge_request
  # #has_one :finalize_challenge
  # belongs_to :recipient, class_name: "User"
  # belongs_to :actor, class_name: "User"
  # validates_presence_of :odds_out_of, :message => 'You must say what the odds are out of'
  # validates_presence_of :number_chosen, :message => 'You must pick a number'
  # validate :odds_out_of_min
  # validate :number_chosen_not_middle
  # validate :number_chosen_in_bounds
  # has_one :notification, as: :notifiable
  #
  # def actor_test_method
  #   User.find(challenge_request.recipient_id)
  # end
  #
  # def odds_out_of_min
  #   if not odds_out_of.blank?
  #     if odds_out_of <= 2
  #       errors.add(:odds_out_of, "Odds are must be out of a minimum of 3")
  #     end
  #   end
  # end
  #
  # def number_chosen_not_middle
  #   if not odds_out_of.blank? and not number_chosen.blank?
  #     if odds_out_of % 2 == 0
  #       if number_chosen == odds_out_of / 2
  #         errors.add(:number_chosen, "Your number cannot be the middle number (if the challenger chooses this, both of you would lose)")
  #       end
  #     end
  #   end
  # end
  #
  # def number_chosen_in_bounds
  #   if not odds_out_of.blank? and not number_chosen.blank?
  #     if number_chosen >= odds_out_of
  #       errors.add(:number_chosen, "Your number must be less than what the odds are out of")
  #     end
  #     if number_chosen < 1
  #       errors.add(:number_chosen, "Your number must be at least 1")
  #     end
  #   end
  # end

end
