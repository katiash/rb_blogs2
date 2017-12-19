class Blog < ActiveRecord::Base
    has_many :posts # Blog posts OF COURSE!

    has_many :owners
    has_many :users, through: :owners # all users that own a specific blog

    has_many :users_who_posted, through: :posts, source: :user ## why?

    validates :name, :description, presence: true
end

## 3.times do |i| Blog.owners: 