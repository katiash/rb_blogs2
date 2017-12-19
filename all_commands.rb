# Initial commands
# rails new blog1
# rails g model Blog name:string description:text
# rails g model Post title:string content:text blog:references
# rails g model Message author:string message:text post:references


rake db:migrate
# 1. create 5 new users:
users=[["Joe", "Doe", "joe@doe.com"], ["Jane", "Doe", "jane@doe.com"], ["Jake", "Doe", "jake@doe.com"], ["Mich
ael", "Smith", "Michael@Smith.Com"], ["Michelle", "Smith", "michelle@smith.COM"]]
1.upto(5) { |i| User.create(first_name: users[i-1][0], last_name: users[i-1][1], email_address: users[i-1][2])
}

# 2. create 5 blogs:
1.step(5) { |n| Blog.create(name: "Blog #{n}", description: "This is description for Blog #{n}")}

# 3. Have the first 3 blogs be owned by the first user:
first_user = User.first OR User.where("id == ?", 1)[0]
3.times { |i| first_user.owners.create(blog_id: i)}

OR 

Owner.create(user: User.first, blog: Blog.first)
Owner.create(user: User.first, blog: Blog.second)
Owner.create(user: User.first, blog: Blog.third)

# 4. Have the 4th blog you create be owned by the second user:
Owner.create(user: User.second, blog: Blog.fourth)

# 5. Have the 5th blog you create be owned by the last user:
Owner.create(user: User.last, blog: Blog.fifth)

# 6. Have the third user own all of the blogs that were created.  
Blog.all.each { |blog| Owner.create(user: User.third, blog:blog)}

# 7. Have the first user create 3 posts for the blog with an id of 2.
# NOTE: Migration had to be created manually to update Schema with user_id FK in Posts:
rails g migration Add UserIdToPosts # EDIT New Migration File:

class Add < ActiveRecord::Migration
  def change
    add_column :posts, :user_id, :integer
  end
end

#THEN:
rake db:migrate

first_user=User.where("id == ?", 9).first #finds list of records with WHERE; empty list if not found
first_user=User.find_by("id == ?", 9) #finds single record with find_by or find; nil if not found

3.times {|i| Post.create(blog: Blog.find(2), user: first_user, title:"Title #{i}", content:"Content fo
r Post #{i}" )}

# Remember that you shouldn't do:

# Post.create(user: User.first, blog_id: 2), but more like:
# Post.create(user: User.first, blog: Blog.find(2)). 
# Again, you should never reference the foreign key in Rails DIRECTLY. 

# 8. Have the second user create 5 posts for the last Blog:
second_user = User.find_by(id:2)
5.times {|i| Post.create(blog: Blog.last, user: second_user, title:"Title #{i}", content:"Content for Post #{i}" )}

# 9. Have the 3rd user create several posts for different blogs:
# Post.maximum(:id) + 1 = 8 + 1

Post.create(title: "Post ##{Post.maximum(:id) + 1}", content: "This is the content for post ##{Post.maximum(:id) + 1}", user: User.third, blog: Blog.third)
Post.create(title: "Post ##{Post.maximum(:id) + 1}", content: "This is the content for post ##{Post.maximum(:id) + 1}", user: User.third, blog: Blog.fourth)
Post.create(title: "Post ##{Post.maximum(:id) + 1}", content: "This is the content for post ##{Post.maximum(:id) + 1}", user: User.third, blog: Blog.fifth)

# 10. Have the 3rd user create 2 messages for the first post created and 3 messages for the second post created:
#NOTED: The Schema was again outdate and did not include FK user_id. So:
rails g migration AddUserIdToMessages user_id:integer
#AND:
class AddUserIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :user_id, :integer
  end
end

Message.create(author: "Apple Inc", message: "My products are the best", user: User.third, post: Post.first)
Message.create(author: "Microsoft", message: "No way!", user: User.third, post: Post.first)
Message.create(author: "NBA", message: "Basketball is the best sport", user: User.third, post: Post.second)
Message.create(author: "FIFA", message: "We have the world cup. We are the best", user: User.third, post: Post.second)
Message.create(author: "NFL", message: "We are the real football", user: User.third, post: Post.second)

# 11. Have the 4th user create 3 messages for the last post you created:
Message.create(author: "Some Author", message: "My book is the best", user: User.fourth, post: Post.last)
Message.create(author: "Another Author", message: "Your book is really good indeed", user: User.fourth, post: Post.last)
Message.create(author: "Some Other Author", message: "Agree!", user: User.fourth, post: Post.last)

# 12. Change the owner of the 2nd post to the last user:
Post.second.update(user: User.last)

# 13. Change the 2nd post's content to be something else:
Post.second.update(content: "Changing content to something different.")

# 14. Retrieve all blogs owned by the 3rd user (make this work by simply doing: User.find(3).blogs):
User.third.blogs #Using *has_many :blogs, through: :owners* relationship in User class. 

# 15. Retrieve all posts that were created by the 3rd user:
User.third.posts

# 16. Retrieve all messages left by the 3rd user:
User.third.messages

# 17. Retrieve all posts associated with the blog id 5 as well as who left these posts:
Post.joins(:user, :blog).where('blogs.id=5').select("posts.*, users.first_name, users.last_name ")

# 18. Retrieve all messages associated with the blog id 5 along with all the user information of those who 
# left the messages. In this problem, we need to do a subquery:
Message.joins(:post, :user).where('posts.blog_id = 5').select("messages.*,users.*, posts.blog_id")
# CAN NOT HAVE .where(blog.id: 5...6) BECAUSE NO blog.id in message ORM object. Can only do this way otherwise:
Message.joins(:user).where(post: Blog.find(5).posts).select("*")
# OR AS IN first query solution, via RAW SQL with quotes naming actual SQLite tables (posts, users, etc..)

# 19. Grab all user information of those that own the first blog (make this work by allowing Blog.first.owners 
# to work):
Blog.first.users

# 20. Change it so that the first blog is no longer owned by the first user:
Owner.where("id = ? AND user_id = ?", 1, 1,).update_all("user_id = 5")
# OR: 
Owner.where(blog: Blog.first, user: User.first)[0].destroy

# FROM BLOGS1:
# 9. know how to retrieve all blogs whose id is less than 5.
Blog.where("id < ?", 5)
Blog.where(id: 1...5) 

