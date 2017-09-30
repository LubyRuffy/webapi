class LicensesController < ApplicationController
  skip_before_action :require_login

  def index
    logger.info("LicensesController index")
  end

  def create
    logger.info("LicensesController create")
  end

  def activate
    logger.info("LicensesController activate")
  end
end
