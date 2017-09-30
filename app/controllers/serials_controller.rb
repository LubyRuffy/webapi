class SerialsController < ApplicationController
  skip_before_action :require_login

  require 'crc32'

  def index
    names = %w(mac uuid cpuid)

    info = ''
    names.each do |name|
      info += get_info(name)
    end

    #logger.info("info #{info}")
    crc32 = Crc32.calculate(info, info.length, 0)

    @serial = "012000" + crc32.to_s
    logger.info("serial: #{@serial}")

    @dev_serial = Serial.first
    if !@dev_serial 
      @dev_serial = Serial.new

      @dev_serial.serial = @serial
      @dev_serial.save
    end
  end

  private 

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
