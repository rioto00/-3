class UsersController < ApplicationController
  def index
    @user = current_user
    @book = Book.new
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books
  end
  
  def update
    is_matching_login_user
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.save
      redirect_to user_path(@user.id)
      flash[:notice] = "You have updated user successfully."
    else
      #@user = current_user
      @users = User.all
      render :edit
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(@user.id)
    end
    end
  end

  def edit 
    is_matching_login_user
    @user = User.find(params[:id])
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user.id)
    end 
  end
  
  def create
    flash[:notice] = "Welcome! You have signed up successfully."
    redirect_to user_path(@user.id)
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
  
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user.id)
    end
  end
  
end
