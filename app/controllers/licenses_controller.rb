class LicensesController < ApplicationController
  skip_before_action :require_login

  require 'crc32'

  def index
    logger.info("LicensesController index")
  end

  def create
    logger.info("LicensesController create")
    @license = params[:license]
    if !@license
      logger.info("license nil")
      api_err(20032, 'invalid license')
      return
    end

    # Base64 decode the license first
    license_decode = Base64.decode64(@license)

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
    @license_db.license = @license 
    @license_db.valid_time = @valid_time 
    @license_db.expired_time = @expired_time 
    @license_db.activated = false 

    if !@license_db.save
      logger.info("save error")
      api_err(20032, 'invalid license')
      return
    end

  end

  def activate
    logger.info("LicensesController activate")
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
    serial_license == Serial.first.serial
  end

  def parse_license(license)
    valid_time = license[0, 6]
    license_time = license[24,3]

    year = '20' + valid_time[0,2]
    month = valid_time[2,2]
    day = valid_time[4,2]
    @valid_time = Time.mktime(year, month, day, 0, 0, 0)

    logger.info("valid_time = #{@valid_time}, t = #{Time.now} ")
    if @valid_time < Time.now
      @valid_time = nil
      return false 
    end

    t = Time.now
    months = t.month + license_time.to_i

    year = months.to_i/12 + t.year 
    month = months.to_i%12

#    binding.pry
    expired_time = Time.mktime(year, month, t.day, t.hour, t.min, t.sec)

    logger.info("expired_time = #{expired_time}, t = #{t} #{expired_time < t}")

    if (expired_time < t)
      @expired_time = nil
      return false 
    end

    @expired_time = expired_time
  end
end
