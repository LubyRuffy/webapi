module TyphoeusRequest
  require 'typhoeus'

  port = 7331
  host = '127.0.0.1'

  URL = 'http://' + host + ':' + port.to_s

  def _request( path = 'scans', options = {} ) # can't named 'request' , conflict with rails's request.
    if (data = options.delete(:data))
      options[:body] = JSON.dump( data )
    end

    begin
      response = Typhoeus::Request.new(
          "#{URL}/#{path}",
          options.merge(
              # Enable compression.
              accept_encoding: 'gzip, deflate',
          )
      ).run
    rescue Exception => e
      logger.info("Typhoeus run error. #{e}")

      fail e
    end

    fail response.return_message if response.code == 0

    JSON.load( response.body )
  end

  def get( path )
    _request( path , method: :get) # Method get can delete. The get Method is default.
  end

  def post( path, data = nil )
    _request( path, data: data, method: :post )
  end

  def delete( path )
    _request( path, method: :delete )
  end

  def _put(path)
    _request( path, method: :put )
  end

  # ----------------↑ Http Basic Methods.--------------------

  # ----------------↓ Arachni Methods -----------------------

  def get_scan_lists
    get("scans")
  end

  # return scans id .
  # data = {
  #   url: 'http://192.168.54.251:8080/wavsep/active/index-sql.jsp',
  #   "checks": ["sql*", "xss*"],
  #   "scope": {
  #       "page_limit": 500,
  #           "exclude_path_patterns": [
  #           "logout",
  #           "security",
  #           "login",
  #           "setup"
  #       ]
  #    },
  #    "plugins": {
  #        "autologin": {
  #           "url": "http://192.168.54.250/dvwa/login.php",
  #           "parameters": "username=admin&password=admin&Login=Login",
  #           "check": "PHPIDS"
  #        }
  #    },
  #    "session": {
  #        "check_url": "http://192.168.54.250/dvwa/index.php",
  #        "check_pattern": "PHPIDS"
  #    }
  # }
  def create_scans_task(path, data=nil)
    post(path, data)['id'] # Return the scans id. If Nil, represent scans create failure.
  end

  # return scans cluster info, issues , site maps .
  def get_info_from_scans(id=0)
    get "scans/#{id}" # {} represent , no scan task exist.
  end

  # return null.
  def delete_scans_task(id=0)
    delete "scans/#{id}"
  end

  # return true or false
  def pause_scans(id=0)
    _put "scans/#{id}/pause"
  end

  # return true or false
  def resume_scans(id=0)
    _put "scans/#{id}/resume"
  end

  def stop_scans(id) # Restful has no stop operation yet.
    nil
  end
end
