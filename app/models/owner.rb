class Owner < ActiveRecord::Base
  belongs_to :user
  belongs_to :blog

  validates :blog_id, uniqueness: {scope: :user_id, message: "User can only own a unique Blog once."} 
end
