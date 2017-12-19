class User < ActiveRecord::Base

    EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i

    has_many :blogs, through: :owners ## 
    has_many :owners
    
    has_many :posts
    has_many :messages
    has_many :blogs_posted_on, through: :posts, source: :blog # through: specifies the join model

    validates :email_address, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
    validates :first_name, :last_name, :email_address, presence: true

end
