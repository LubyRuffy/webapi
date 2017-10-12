class LicensesController < ApplicationController
  skip_before_action :require_login

  require 'crc32'

  def index
    logger.info("LicensesController index")
    @license_db = License.first 

    if @license_db
      @expired_time = (@license_db.once_activated)?(@license_db.expired_time.localtime.to_s):nil
    else 
      @expired_time = nil
    end
  end

  def create
    logger.info("LicensesController create")
    license = params[:license]
    if !license
      logger.info("license nil")
      api_err(20032, 'invalid license')
      return
    end

    # Check the license in the history
    if LicenseHistory.find_by(license: license)
      api_err(20032, "invalid license")
      return
    end

    # Base64 decode the license first
    license_decode = Base64.decode64(license)

    # Then decrypt the license 
    # Check the crc last.
    # Serial No check 
    @license = decrypt_license(license_decode)
    if !@license || !crc_check(@license) || !serial_check(@license)
      logger.info("decode, crc_check, serial check error")
      api_err(20032, 'invalid license')
      return
    end

    # Parse lincese and write into db
    if !parse_license(@license)
      logger.info("parse error")
      api_err(20032, 'invalid license')
      return
    end

    # Write in db through ORM
    if !License.first 
      # Lincese new
      @license_db = License.new
    else
      @license_db = License.first
    end

#    @license_db = License.first?License.first():License.new
    @license_db.license = license 
    @license_db.valid_time = @valid_time 
    #@license_db.expired_time = @expired_time 
    @license_db.months = @months
    @license_db.activated = false 

    if !@license_db.save
      logger.info("save error")
      api_err(20032, 'invalid license')
      return
    end

  end

  def activate
    logger.info("LicensesController activate")
    @license_db = License.first

    if !@license_db
      api_err(16811, "No inactive license")
      return
    end

    # Chech the license activated first
    if @license_db.activated 
      api_err(16788, "License had already active")
      return
    end

    # If not activated, Check is there a license ?
    if !@license_db.license 
      api_err(16811, "No inactive license")
      return
    end

    # Then check the license's valid_time is valid or not .
    if (@license_db.valid_time < Time.now) 
      api_err(20032, "invalid license")
      return
    end

    if (@license_db.expired_time)
      if (@license_db.expired_time < Time.now)
        api_err(20032, "invalid license")
        return
      end
    end

#    t = Time.now
    t = (@license_db.expired_time)?(@license_db.expired_time):Time.now

    months = t.month + @license_db.months
    year, month = get_year_month(t, months)

    binding.pry
    begin 
      expired_time = Time.mktime(year, month, t.day, 0, 0, 0)
      #expired_time = Time.mktime(year, month, t.day, t.hour, t.min, t.sec)
    rescue => e
      logger.error("Time.mktime error => #{e}")
      api_err(20032, "invalid license")
      return
    end

    @license_db.activated = true
    @license_db.once_activated = true
    @license_db.expired_time = expired_time

    if !@license_db.save
      api_err(20032, "invalid license")
      return
    end

    license_history = LicenseHistory.new(:license => @license_db.license)

    if !license_history.save
      logger.error("license history write error")
    end
    
  end

  private

  def decrypt_license(license)
    logger.info("in decrypt")
    begin
      dec = OpenSSL::Cipher.new("DES-CBC")
      dec.decrypt
      dec.key = "Venusutm"
      dec.iv = "licenses"
      dec.padding = 0
      license_decrypt = dec.update(license)
      puts dec.final
      license_decrypt << dec.final
    rescue => e
      logger.error("decrypt license error => #{e}")
      license_decrypt = nil
    end

    return license_decrypt
  end

  def crc_check(license)
    #binding.pry
    logger.info("in crc_check")
    license_len = license.length
    crc32 = Crc32.calculate(license[0, license_len-4], license_len-4, 0)
    crc = license[license_len-4 .. license_len]

    license = license[0, license_len-4]

    (crc32%10000) == crc.to_i
  end

  def serial_check(license)
    logger.info("in serial_check")
    serial_license = license[8,16]
    if !Serial.first
      generate_serial
    end
    serial_license == Serial.first.serial
  end

  def parse_license(license)
    # license 171001  is 2017-10-01
    valid_time = license[0, 6]
    license_time = license[24,3]

    year = '20' + valid_time[0,2]
    month = valid_time[2,2]
    day = valid_time[4,2]
    @valid_time = Time.mktime(year, month, day, 0, 0, 0)

    #logger.info("valid_time = #{@valid_time}, t = #{Time.now} ")
    if @valid_time < Time.now
      @valid_time = nil
      return false 
    end

    t = Time.now
    months = t.month + license_time.to_i
    year ,month = get_year_month(t, months.to_i)

    begin 
      expired_time = Time.mktime(year, month, t.day, t.hour, t.min, t.sec)
    rescue => e
      logger.error("Time.mktime error => #{e}")
      return false
    end

    #logger.info("expired_time = #{expired_time}, t = #{t} #{expired_time < t}")
    if (expired_time < t)
      return false 
    end

    #@expired_time = expired_time
    @months = license_time.to_i
  end

  def get_year_month(time, months)
    if months > 12
      year = months/12 + time.year
      month = months%12 
    else
      year = time.year
      month = months
    end
    return year, month
  end
end
