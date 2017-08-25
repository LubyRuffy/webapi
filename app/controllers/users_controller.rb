class UsersController < ApplicationController

  before_action :session_timeout?
  
  def index
    #render json: User.all
    @user = User.all
  end

  def create
   # @user = User.new
    logger.info("----params----#{require.POST()} ----")
    @user = User.new(create_params)

    if !@user.save
      api_err 20004, 'user create error'
    end
  end

  def delete
    User.find(params[:id]).destroy
  end

  def show
    @user = User.find_by(id: params[:id])
    if !@user
      api_err 86, "User does not exist"
    end
#    render json: @user
  end

  def update
    @user = User.find(params[:id])

    if !user_can_change_info? 
        api_err 20002, "User info only can be changed by self or admin user"
    end

    if !@user.update_attributes(update_params)
      api_err 20003, "User info update error!"
      #@err_code = 20003
      #@err_msg = "User info update error!"
    end
  end

  private

  def create_params
    require.request_parameters.permit(:username, :password, :email, :phone_no, :description, :role_id)
  end

  def update_params
    params.permit(:password, :email, :phone_no, :description,:role_id)
  end


  # Check the user can change the info or not.
  # if the user which to change is not the user which login now, or 
  # the user logined is not the  user adminastrator. It return false.
  def user_can_change_info?
    @user_to_modify = User.find(params[:id])
    @user_now  = User.find_by(username: params[:user])

    if !@user_now
      return false
    end

    if (@user_to_modify != params[:user]) && (@user_now.role_id != 2)
      false
    else
      true
    end
  end
end
