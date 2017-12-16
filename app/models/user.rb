class User < ApplicationRecord
  has_friendship
  has_many :notifications, foreign_key: :recipient_id
  has_many :sent_challenge_requests, class_name: "ChallengeRequest", foreign_key: :actor_id
  has_many :received_challenge_requests, class_name: "ChallengeRequest", foreign_key: :recipient_id
  has_many :challenge_response, foreign_key: :recipient_id
  has_many :friend_requests, foreign_key: :targeting_user
  validates_uniqueness_of :user_name, :case_sensitive => false
  extend FriendlyId
  before_validation :generate_slug
  validate :user_name_not_profane
  before_save :uppercase_names


  friendly_id :user_name, use: [:slugged, :finders]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def user_name_not_profane
    if not user_name.blank?
      swears = ['anal','anus','arse','ass','ballsack','balls','bastard','bitch','biatch','blowjob','boner','boob','butt','buttplug','clitoris','cock','coon','cunt','dick','dildo','dyke','fag','feck','fuck',
        'homo','jizz','nigger','nigga','penis','piss','prick','pube','pussy','queer','scrotum','sex','shit','sh1t','slut','tit','vagina','whore']
      if swears.include?(user_name)
        errors.add(:user_name, "User name inappropriate, please choose another")
      end
    end
  end

  def full_name
    first_name + " " + last_name
  end

  def has_friends
    friends.any?
  end

  def has_friend_requests
    requested_friends.any?
  end

  def

  def anchor
    "(@#{user_name})"
  end

  def to_s
    first_name + " " + last_name + " @(#{user_name})"
  end

  def num_current_odds_ares
    sent_challenge_requests.where(responded_to_at: nil).size + received_challenge_requests.where(responded_to_at: nil).size
  end

  def has_current_odds_ares
    num_current_odds_ares != 0
  end

  def challenge_requests_waiting_on_friends
    sent_challenge_requests.where(responded_to_at: nil)
  end

  def challenge_requests_waiting_on_user
    received_challenge_requests.where(responded_to_at: nil)
  end

   private
     def generate_slug
       self.slug = user_name.to_s.parameterize
     end

     def uppercase_names
       self.first_name = self.first_name.upcase_first
       self.last_name = self.last_name.upcase_first
     end
end
