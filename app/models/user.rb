class User < ApplicationRecord
  has_friendship
  has_many :notifications, foreign_key: :recipient_id
  has_many :challenge_requests, foreign_key: :recipient_id
  has_many :challenge_response, foreign_key: :recipient_id
  has_many :friend_requests, foreign_key: :targeting_user
  extend FriendlyId
  before_validation :generate_slug
  validate :user_name_not_profane


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

  def to_s
    "test"
  end

   private
     def generate_slug
       self.slug = user_name.to_s.parameterize
     end
end
