# == Schema Information
# Schema version: 20110430041448
#
# Table name: users
#
#  id         :integer         not null, primary key
#  loginname  :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	attr_accessible :loginname, :email
	
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	loginname_regex = /\A[\w\d]+\z/i
	
	validates :loginname, :presence   => true,
					     :format     => { :with => loginname_regex },
						 :length     => { :maximum => 30},
						 :uniqueness => { :case_sensitive => false }
	validates :email,    :presence   => true,
                         :format     => { :with => email_regex },
                         :uniqueness => { :case_sensitive => false }
end
