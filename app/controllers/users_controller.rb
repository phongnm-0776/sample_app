class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by params[:id]
    redirect_to signup_path if @user.nil?
  end
end
