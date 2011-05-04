class UsersController < ApplicationController
	
  def show
  	@user = User.find(params[:id])
  	@title = @user.loginname
  end	
  def new
  	@title = "Sign up"
  end

end
