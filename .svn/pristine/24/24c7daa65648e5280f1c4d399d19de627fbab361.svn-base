class LogoutController < ApplicationController
  def logout
  #  delete_sessions(params[:sessions])
    logger.info("logout session #{params[:session]}")
    delete_session!(params[:session])
  end
end
