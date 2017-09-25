class DiskchecksController < ApplicationController
  include MysqlMonitor
  include DiskMonitor

  def index
    @limit = Diskcheck.first

    if !@limit 
      api_err 20016, "data get error"
      return
    end

    @db_full, @db_size = get_size('db', @limit)
    @report_full, @report_size = get_size('disk', @limit)
  end

  def create
    @limit = Diskcheck.first
    
    if !@limit
      logger.info("no disckchecks ,create it")
      begin 
        Diskcheck.create(params[:diskchecks])
      rescue => e
        logger.info("create DisckChecks Error.")
        logger.error("#{e}")
        api_err 20015, "update error"
        return
      end
    end

    begin
      @limit.update_attributes(update_params)
    rescue => e
      logger.info("update limit error")
      logger.error("#{e}")
      api_err 20015, "update error"
      return
    end

  end

  private 

  def get_size(name, limit)
    size = send "get_#{name}_size" # get_db_size, get_disk_size
    size = size.to_i # size is string ,change it to integer.

    if name == 'db'
      limit_size = limit.db_limit*1024*1024
    elsif name == 'disk'
      limit_size = limit.report_limit*1024*1024
    end

    full_flag = 0 
    if size >= limit_size*0.85 && size < limit_size*0.95
      full_flag = 1
    elsif size >= limit_size*0.95
      full_flag = 2
    end

    return full_flag, size
  end

  def update_params
    params.require(:diskcheck).permit(:db_limit, :report_limit)
  end
end
