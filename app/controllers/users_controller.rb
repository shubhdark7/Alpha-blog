class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]
  
  
  def index
  
  @users = User.paginate(page: params[:page], per_page: 5)
  
  end
  
  
  
  def new
    
    @user = User.new
    
  end
  
  def create
    
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "User has been successfully created"
      redirect_to user_path(@user)
    else
      render 'signup'
    end
  
  end
  
  def edit

  end
  
  def update
  

  if @user.update(user_params)
    flash[:success] = "User successfully got updated"
    redirect_to articles_path
  else
    render 'edit'
  end
  
  end
  
  def show
  
  
  @user_articles = @user.articles.paginate(page: params[:page], per_page:1)
  
  end

  def destroy
    
    @user = User.find(params[:id])
    
    if @user.destroy
      flash[:danger] = "User and their corresponding articles have been successfully deleted"
      redirect_to users_path
    end
    
  end
  
  def set_user
  
  @user = User.find(params[:id])
    
  end
  
  def require_same_user
  
  if current_user != @user and !current_user.admin?
  flash[:danger] = "You can only edit your own account"
  redirect_to root_path
    
  end
  
  end
  
  def require_admin
    
    if logged_in? and !current_user.admin?
    flash[:danger] = "Only admin users can perform that action"
    redirect_to root_path
    end      
      
    
  end
    
  
  private
  def user_params
    
    params.require(:user).permit(:username, :email, :password)
    
  end    
    

  
end