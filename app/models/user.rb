class User < ApplicationRecord
  extend FriendlyId
  before_validation :generate_slug


  friendly_id :user_name, use: [:slugged, :finders]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   private
     def generate_slug
       self.slug = user_name.to_s.parameterize
     end
end
