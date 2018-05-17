class User < ApplicationRecord
  ### Associations ###
  has_friendship
  has_many :notifications, foreign_key: :recipient_id
  has_many :sent_odds_ares,
           class_name: 'OddsAre',
           foreign_key: :initiator_id,
           dependent: :delete_all
  has_many :received_odds_ares,
           class_name: 'OddsAre',
           foreign_key: :recipient_id,
           dependent: :delete_all
  has_many :lost_odds_ares, class_name: 'Task', foreign_key: :loser_id
  has_many :won_odds_ares, class_name: 'Task', foreign_key: :winner_id

  ### Validations ###
  validates_uniqueness_of :user_name, case_sensitive: false
  validates_presence_of :user_name
  validates_presence_of :first_name
  validates_presence_of :last_name
  validate :clean_user_name
  validate :clean_first_name
  validate :clean_last_name

  ### Callbacks ###
  before_save :uppercase_names
  before_validation :generate_slug

  ### External usages ###
  extend FriendlyId
  friendly_id :user_name, use: %i[slugged finders]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ### Helper methods ###
  def full_name
    first_name + ' ' + last_name
  end

  def has_friends
    friends.any?
  end

  def has_friend_requests
    requested_friends.any?
  end

  def total_odds_ares
    sent_odds_ares + received_odds_ares
  end

  def completed_odds_ares
    sent_odds_ares.where.not(finalized_at: nil) + received_odds_ares.where.not(finalized_at: nil)
  end

  def has_lost_odds_ares
    !lost_odds_ares.empty?
  end

  def has_current_odds_ares
    (sent_odds_ares.where(finalized_at: nil) + received_odds_ares.where(finalized_at: nil)).any?
  end

  def num_current_odds_ares
    (sent_odds_ares.where(finalized_at: nil) +
      received_odds_ares.where(finalized_at: nil)).size
  end

  def dares_completed
    lost_odds_ares.where.not(loser_marked_completed_at: nil, winner_marked_completed_at: nil)
  end

  def challenge_requests_waiting_on_friends_to_set
    sent_odds_ares.where(responded_to_at: nil)
                  .joins(:challenge_request)
                  .collect(&:challenge_request)
  end

  def challenge_requests_waiting_on_user_to_set
    received_odds_ares.where(responded_to_at: nil)
                      .joins(:challenge_request)
                      .collect(&:challenge_request)
  end

  def challenge_responses_waiting_on_user_to_complete
    sent_odds_ares.where(finalized_at: nil)
                  .joins(:challenge_response)
                  .collect(&:challenge_response)
  end

  def challenge_responses_waiting_on_friends_to_complete
    received_odds_ares.where(finalized_at: nil)
                      .joins(:challenge_response)
                      .collect(&:challenge_response)
  end

  ### Validation methods ###
  def clean_user_name
    profanity_filter = LanguageFilter::Filter.new matchlist: :profanity
    if profanity_filter.match? user_name
      errors.add(:user_name, "The following language is inappropriate in a
         username: #{profanity_filter.matched(user_name).join(', ')}")
    end
  end

  def clean_first_name
    profanity_filter = LanguageFilter::Filter.new matchlist: :profanity
    if profanity_filter.match? first_name
      errors.add(:first_name, "The following language is inappropriate in a
         first name: #{profanity_filter.matched(first_name).join(', ')}")
    end
  end

  def clean_last_name
    profanity_filter = LanguageFilter::Filter.new matchlist: :profanity
    if profanity_filter.match? last_name
      errors.add(:last_name, "The following language is inappropriate in a
         last name: #{profanity_filter.matched(last_name).join(', ')}")
    end
  end

  ### Callback methods ###

  private

  def generate_slug
    self.slug = user_name.to_s.parameterize
  end

  def uppercase_names
    self.first_name = first_name.upcase_first
    self.last_name = last_name.upcase_first
  end
end
