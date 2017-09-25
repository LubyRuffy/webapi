class LoginController < ApplicationController
  skip_before_action :require_login, only:[ :create ], raise: false

  def create
    @username = params[:username]
    @password = params[:password]

    # if @username is nil ,@user = nil. Else chech user exist or not.
    @user = @username && User.find_by(username: @username)
    @err_code = 0
    @err_msg = ''
    if @user && @password == @user.password
      if params[:session] #&& @sessions.key?(params[:session])
    #    @@session_cache[params[:session]] = Time.now
        update_session!(params[:session])
        logger.info("session in login: #{@@session_cache[params[:session]]}")
      else
        @err_code = 260
        @err_msg = 'Session isn\'t exist'
      end

    else
      @err_code = 266
      @err_msg = 'Password is incorrect'
    end
  end
end
