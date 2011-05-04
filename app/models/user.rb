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
require 'digest'
class User < ActiveRecord::Base
	attr_accessor   :password
	attr_accessible :loginname, :email, :password, :password_confirmation
	
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	loginname_regex = /\A[\w\d]+\z/i
	password_regex = /\A(?=.*[\d])(?=.*[A-Z])([1-zA-Z0-1@*#$.]{6,20})\z/
	
	validates :loginname, :presence     => true,
					      :format       => { :with => loginname_regex },
						  :length       => { :maximum => 30},
						  :uniqueness   => { :case_sensitive => false }
	validates :email,     :presence     => true,
                          :format       => { :with => email_regex },
                          :uniqueness   => { :case_sensitive => false }
    validates :password,  :presence     => true,
                          :confirmation => true,
                          :length       => { :within => 6..20 },
                          :format       => { :with => password_regex }
                          
    before_save :encrypt_password
    
    def has_password?(submitted_password)
    	encrypted_password == encrypt(submitted_password)
	end
	
	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil  if user.nil?
		return user if user.has_password?(submitted_password)
	end
    
    private
    
      def encrypt_password 
    	self.salt = make_salt if new_record?
      	self.encrypted_password = encrypt(password)
  	  end
  	  
  	  def encrypt(string)
  	  	secure_hash("#{salt}--#{string}")
  	  end
  	  
  	  def make_salt
  	  	secure_hash("#{Time.now.utc}--#{password}")
  	  end
  	  
  	  def secure_hash(string)
  	  	Digest::SHA2.hexdigest(string)
  	  end
end
