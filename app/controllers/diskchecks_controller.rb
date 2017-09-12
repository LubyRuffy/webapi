class DiskchecksController < ApplicationController
  include MysqlMonitor
  include DiskMonitor

  def index
    @limit = Diskcheck.first

    if !@limit 
      api_err 20016, "data get error"
    end

    @db_full, @db_size = get_size('db', @limit)
    @report_full, @report_size = get_size('disk', @limit)

=begin    
    @db_size = get_size('db', @limit) # Value return is *Kb
    #@db_size = get_db_size # Value return is *Kb

    @db_full = 0 
    logger.info("db size is #{@db_size}")
    db_limit = @limit.db_limit*1024*1024 #db_limit is *GB, so *1024**2. 85% will be warning. 95 will be limit function
    if @db_size.to_i >= db_limit*0.85 && @db_size.to_i < db_limit*0.95
      @db_full = 1
    elsif @db_size.to_i >= db_limit*0.95 #
      @db_full = 2
    end

    @report_full = 0
    @report_size = get_size('disk') #return is Kb

    logger.info("report size is #{@report_size}")
    report_limit = @limit.report_limit*1024*1024 #db_limit is *GB, so *1024**2. 85% will be warning.
    if @report_size.to_i >= report_limit*0.85 && @report_size.to_i < report_limit*0.95
      @report_full = 1
    elsif @report_size.to_i >= report_limit*0.95
      @report_full = 2
    end
=end
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
      end
    end

    begin
      @limit.update_attributes(update_params)
    rescue => e
      logger.info("update limit error")
      logger.error("#{e}")
      api_err 20015, "update error"
    end

  end

  private 

  def get_size(name, limit)
    size = send "get_#{name}_size"
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
