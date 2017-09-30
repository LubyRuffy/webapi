class NetworkConfigController < ApplicationController
#  skip_before_action :require_login

  def index
    interface_file = "/etc/network/interfaces"
    begin 
      fp = File.open(interface_file, 'r')

      @address = nil
      @gateway = nil
      @type = 1
      @interface = get_ether_interface 

      while line = fp.gets
        if line.include?("address") 
          @address = line.split(" ")[1]
        elsif line.include?("gateway")
          @gateway = line.split(" ")[1]
        #elsif line.include?("auto ")
        #  unless line.split(" ")[1] == "lo"
        #    @interface = line.split(" ")[1] 
        #  end
        end
      end

      logger.info("address: #{@address}, gateway #{@gateway}, interfaces #{@interface}")
    rescue => e
      logger.error("network read error => #{e}")
      fp.close if fp
      api_err(20028, "network configure read error")
      return
    end
  end

  def create
    if !params[:gateway] || !params[:address]
      api_err 20029, "ip can not be null"
      return 
    end

    if !IPAddress.valid?(params[:gateway])
      logger.info("gateway: #{params[:gateway]}")
      api_err(24, "Invalid gateway")
      return
    end

    if !valid_subnet?(params[:address])
      api_err(41, "Invalid ip address")
      return
    end

    begin 
      system("mv /etc/network/interfaces /etc/network/interfaces.bak")
      fp = File.open("/etc/network/interfaces", 'w+')
      write_conf_into_inface_file(fp, params[:address], params[:gateway], 1)
    rescue => e
      logger.error("Write network configure error => #{e}")
      api_err(20030, "write network configure error")
      system("mv /etc/network/interfaces.bak /etc/network/interfaces")
      fp.close if fp
      return 
    ensure
      fp.close if fp
      system("rm /etc/network/interfaces.bak")
    end

    system("/sbin/ifconfig #{@inface} #{params[:address]}")
    system("service networking restart")
  end

  private

  def valid_subnet?(addr)
    ip, mask = addr.split("/")
    IPAddress.valid?(ip) && is_numeric?(mask) && (mask.to_i<=32 && mask.to_i > 0)
  end

  def is_numeric?(num)
    return true if num.is_a?(Numeric)
    num.to_i.to_s == num
  end

  def write_conf_into_inface_file(fp, address, gateway, type)
    @inface = get_ether_interface
    logger.info("inface: #{@inface}")
    @inface = @inface?@inface.strip : "ens33"

    begin 
      fp.puts("auto lo")
      fp.puts("iface lo inet loopback")
      fp.puts("")
      fp.puts("auto #{@inface}")
      fp.puts("iface #{@inface} inet static") if type == 1
      fp.puts("address #{address}")
      fp.puts("gateway #{gateway}")
    rescue => e
      raise e
    end
  end
end
