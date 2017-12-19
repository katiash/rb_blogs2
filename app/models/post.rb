class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :blog

  has_many :messages

  validates :content, presence: true
  validates :title, presence: true, length: {minimum: 7}
end
