class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :load_user, except: [:index, :new, :create]
  def new
    @user = User.new
  end

  def index
    @users = User.paginate page: params[:page],
      per_page: Settings.users.index.per_page
  end

  def show
    # load_user
    redirect_to signup_path if @user.nil?
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "flash.welcome"
      redirect_to user_path @user
    else
      render :new
    end
  end

  def edit
    # load_user
    redirect_to login_path if @user.nil?
  end

  def update
    # load_user
    if @user.update_attributes(user_params) && @user.present?
      flash[:success] = t "flash.updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    # load_user
    if @user.destroy
      flash[:success] = t "flash.deleted"
    elsif @user.nil?
      flash[:danger] = t "flash.delete_fail"
    end
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "flash.notlogin"
    redirect_to login_path
  end

  def correct_user
    load_user
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    flash[:danger] = t "flash.nouser" if @user.nil?
  end
end
