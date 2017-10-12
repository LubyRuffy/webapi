class ApplicationController < ActionController::API
#  attr_accessor :sessions 
  before_action :require_login
  
  @@session_cache = {}
  def initialize
    #session = {} # Define in initialize .
#    @@session_cache = {}
  end

  def update_session!(s)
    #@@session_cache[s] = Time.now 
    session[s] = Time.now 
  end
  
  def delete_session!(s)
    #@@session_cache.delete(s) 
    session[s] = nil 
  end

  # require_login
  def require_login
    session_info = request.query_parameters[:session]
    to_flag = true
    logger.info("session_cache = #{session[session_info]}")
    if session.key?(session_info)
      timeOut = Time.now - session[session_info]
      if timeOut < 5*60
        to_flag = false

        #if not timeout , update the time.
        session[session_info] = Time.now

        logger.info("timeOut < 5 min, update session to #{session[session_info]}")
      end
    end
    
    if to_flag
      delete_session!(session_info)
      render json: {err_code: 30000, err_msg: 'session timeout, relogin please'}
    end
  end

  def api_err(err_code, err_msg)
    render json: {err_code: err_code, err_msg:  err_msg}
    return
  end

  def get_ether_interface
    inface = `sudo networkctl 2> /dev/null | grep ether | awk '{print $2}'`                                              
    inface.strip.chomp
  end

  def generate_serial
    names = %w(mac uuid cpuid)

    info = ''
    names.each do |name|
      info += get_info(name)
    end

    #logger.info("info #{info}")
    crc32 = Crc32.calculate(info, info.length, 0)

    @serial = "012000" + crc32.to_s
    logger.info("serial: #{@serial}")
    @dev_serial = Serial.new

    @dev_serial.serial = @serial
    if !@dev_serial.save
      return nil
    end
    return @serial
  end 

  def get_info(name)
    info = self.send "get_#{name}"
    logger.info("#{name} #{info}")
    info
  end

  def get_mac
    inface = get_ether_interface
    `cat /sys/class/net/#{inface.strip}/address`
  end

  def get_uuid
    `blkid | grep -oP 'UUID="\K[^"]+' | sha256sum | awk '{print $1}''"]"' | head -1`
  end

  def get_cpuid
    `dmidecode -t 4 | grep ID |uniq | sed 's/.*ID://;s/ //g' | head -1`
  end
end
