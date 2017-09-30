class DnsConfigController < ApplicationController
  require 'resolv' 
#  require 'ipaddress'
#  skip_before_action :require_login

  def index
    begin 
      fp = File.open("/etc/resolv.conf", 'r')

      @dns1 = nil
      @dns2 = nil
      while line = fp.gets
        if line.include?("nameserver")
          if !@dns1
            @dns1 = line.split(" ")[1]
          else
            @dns2 = line.split(" ")[1]
          end
        end
      end
    rescue => e
      logger.error("read resolv.conf error : #{e}")
      fp.close if fp
      api_err(20023, "dns read error")
      return
    end
    fp.close if fp
  end

  def create
    if !params[:dns1]
      api_err(20025, "dns1 can't be null")
      return
    end

    if !IPAddress.valid?(params[:dns1])
      api_err(41, "Invalid ip address !\n")
      return 
    end

    if params[:dns2] && !IPAddress.valid?(params[:dns2])
      api_err(41, "Invalid ip address !\n")
      return 
    end
    
    system("mv /etc/resolv.conf /etc/resolv.conf.bak")

    begin 
      fp = File.open("/etc/resolv.conf", 'w+')
      fp.puts("nameserver #{params[:dns1]}")
      fp.puts("nameserver #{params[:dns2]}") if params[:dns2]
    rescue => e
      logger.error("write dns error => #{e}")
      api_err(20024, "dns write error")
      fp.close if fp
      system("mv /etc/resolv.conf.bak /etc/resolv.conf")
      return
    ensure
      fp.close if fp
      system("rm /etc/resolv.conf.bak")
    end
  end

  def dns_test
    if !params[:domain]
      api_err(20026, "domain can't be null")
      return
    end

    if params[:domain].length >= 64
      api_err(20027, "doman length is longer than 64")
      return
    end

    begin 
      @ip = Resolv.getaddress(params[:domain])
    rescue => e
      logger.error("get address error => #{e}")
    end
  end
end
