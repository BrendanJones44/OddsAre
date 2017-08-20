class User < ApplicationRecord
  has_friendship
  has_many :notifications, foreign_key: :recipient_id
  extend FriendlyId
  before_validation :generate_slug


  friendly_id :user_name, use: [:slugged, :finders]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def to_s
    "test"
  end

   private
     def generate_slug
       self.slug = user_name.to_s.parameterize
     end
end
