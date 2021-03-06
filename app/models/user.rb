# The class encapsulating all end user behavior and associations
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
  def can_accept_friend_request_from(user)
    if friends.include? user
      raise Exception, 'Friendship already exists'
    elsif user.pending_friends.include? self
      true
    else
      raise Exception, 'No friend request exists to accept'
    end
  end

  def can_send_friend_request_to(user)
    if friends.include? user
      raise Exception, 'Friendship already exists'
    else
      true
    end
  end

  def notification_feed
    notifications.select(:id,
                         :action,
                         :actor_id,
                         :action,
                         :notifiable_id,
                         :notifiable_type)
                 .needs_action
                 .order(created_at: :desc)
  end

  def filtered_friends
    friends.select(:id, :user_name, :first_name, :last_name)
  end

  def full_name
    first_name + ' ' + last_name
  end

  def friends?
    friends.any?
  end

  def unread_notifications?
    notifications.needs_action.any?
  end

  def unread_notifications
    notifications.needs_action
  end

  def friend_requests?
    requested_friends.any?
  end

  def total_odds_ares
    sent_odds_ares + received_odds_ares
  end

  def completed_odds_ares
    sent_odds_ares.where.not(finalized_at: nil) + \
      received_odds_ares.where.not(finalized_at: nil)
  end

  def lost_tasks?
    !lost_tasks.empty?
  end

  def new_auth_token
    update_attribute(:auth_token, random_token)
    auth_token
  end

  def valid_token?(token)
    self.token == token
  end

  def lost_tasks
    OddsAre
      .all
      .joins(:task)
      .merge(Task.where(loser: self)
      .where(loser_marked_completed_at: nil))
  end

  def lost_odds_ares?
    !lost_odds_ares.empty?
  end

  def current_odds_ares?
    (sent_odds_ares.where(finalized_at: nil) + \
      received_odds_ares.where(finalized_at: nil)).any?
  end

  def num_current_odds_ares
    (sent_odds_ares.where(finalized_at: nil) +
      received_odds_ares.where(finalized_at: nil)).size
  end

  def num_completed_odds_ares
    completed_odds_ares.size
  end

  def dares_completed
    lost_odds_ares.where.not(loser_marked_completed_at: nil,
                             winner_marked_completed_at: nil)
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

  def random_token
    SecureRandom.base58(24)
  end
end
