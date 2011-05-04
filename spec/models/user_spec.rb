require 'spec_helper'

describe User do
  
	before (:each) do
	  @attr = { 
	    :loginname => "Marmit", 
	    :email => "user@example.com",
	    :password => "Foobar1",
	    :password_confirmation => "Foobar1"
     }
	end
	
	it "should create a new instance given valid attributes" do
	  User.create!(@attr)
	end
	
	it "should require a name" do
      no_username_user = User.new(@attr.merge(:loginname => ""))
      no_username_user.should_not be_valid
	end
	
	it "should require an email address" do
	  no_email_user = User.new(@attr.merge(:email => ""))
	  no_email_user.should_not be_valid
	end
	
	it "should reject names that are too long" do
      long_username = "a" * 31
      long_username_user = User.new(@attr.merge(:loginname => long_username))
      long_username_user.should_not be_valid
	end
	
	it "should accept valid email addresses" do
	  addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
	  addresses.each do |address|
	  	valid_email_user = User.new(@attr.merge(:email => address))
	  	valid_email_user.should be_valid
      end
	end
	
	it "should reject invalid email addresses" do
	  addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
	  addresses.each do |address|
	  	invalid_email_user = User.new(@attr.merge(:email => address))
	  	invalid_email_user.should_not be_valid
  	  end
	end
	
	it "should accept valid usernames" do
		unames = %w[Marmit3 barmit mar_mit]
		unames.each do |uname|
		 valid_user_name = User.new(@attr.merge(:loginname => uname))
		 valid_user_name.should be_valid
	    end 
	end
	
	it "should reject invalid usernames" do
	  unames = %w[|x_jack_x| money$]
	  unames.each do |uname|
	  	invalid_user_name = User.new(@attr.merge(:loginname => uname))
	  	invalid_user_name.should_not be_valid
      end
	end
	
	it "should reject duplicate email addresses" do
    User.create!(@attr.merge(:loginname => "Marmit"))
    user_with_duplicate_email = User.new(@attr.merge(:loginname => "peter"))
    user_with_duplicate_email.should_not be_valid
  end
	
	it "should reject duplicate user names" do
	  User.create!(@attr.merge(:email => "new@example.com"))
	  user_with_duplicate_username = User.new(@attr.merge(:email => "peter@example.com"))
	  user_with_duplicate_username.should_not be_valid
	end
	
	describe "password validations" do
		
		it "should require a password" do
			User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
		end
		
		it "should require a matching password" do
			User.new(@attr.merge(:password_confirmation => "1nvaliD")).should_not be_valid
		end
		
		it "should reject short passwords" do
		  short = ("a" * 3)+("A5")
		   hash = @attr.merge(:password => short, :passdword_confirmation => short)
		   User.new(hash).should_not be_valid
		end
		
		it "should reject short passwords" do
		  long = ("a" * 19)+("A5")
		   hash = @attr.merge(:password => long, :passdword_confirmation => long)
		   User.new(hash).should_not be_valid
		end
	end
	
	describe "password encryption" do
	  
		before(:each) do
		  @user = User.create!(@attr)	
		end
		
		it "should have an encrypted password attribute" do
		  @user.should respond_to(:encrypted_password)
		end
		
		it "should set the encrypted password" do
		  @user.encrypted_password.should_not be_blank
		end
		
		describe "has_password? method" do
			
			it "should be true if the passwords match" do
				@user.has_password?(@attr[:password]).should be_true
			end
			
			it "should be false it the passwords don't match" do
				@user.has_password?("Inval1d").should be_false
			end
		end
	end
end
