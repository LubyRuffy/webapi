class UpdatesController < ApplicationController
#  skip_before_action :require_login, raise: false
#  skip_before_action :require_login

  def update_checks
    file = FileEncodeDecode.new('AES-256-CBC', 'jtwscsm', '8 octets')
#    file.pack_file()
    check_gz = '/tmp/checks.tar.gz'
    ret = file.unpack_file(check_gz)

    if ret == false
      api_err(20022, 'update checks error')
      return
    end

    # upack the checks.tar.gz 
    `tar xvf #{check_gz} -C /tmp/`

    #
    # Get the name of checks from the file 
    conf_file = '/tmp/checks_name'
    if !File.exist?(conf_file)
      api_err(20022, 'update checks error')
      return
    end

    # TODO
    # Clean the templates db colum, Add new checks name into db.
    plugin_backup = Plugin.all.to_a # Make backup, remember to trans to array.
    Plugin.destroy_all # Attention please. If a error occured, there will no plugin in database.

    # Read the conf file , then add the checks name into database.
    if read_conf_and_add_into_db(conf_file) == false
      api_err(20022, 'update checks error')
      recover_plugin(plugin_backup)   # If update error, recover the checks before.
      return
    end

    #
    # Copy the checks file and nodejs file to the specific directory
    `cp -a /tmp/checks /home/venus/arachni-2.0dev-1.0dev/system/gems/bundler/gems/arachni-6a4135b062d5/components`
    #`cp xx `

    # Stop PM2 and arachni 
    # `kill arachni`
    kill_process('arachni_rest_server')

    #
    # Restart the arachni. Restart by webscan_monitor.rb
    #flag = system('/home/venus/arachni-2.0dev-1.0dev/bin/arachni_rest_server --address 0.0.0.0 > /dev/null 2>&1 &')

    # Restart the node js
    #`pm2 restart 0` # There is only one node process, id is 0. So we restart the 0 process is OK.

    # `rm /tmp/package.bin`
    # `rm /tmp/checks* -rf`

  end

  def read_conf_and_add_into_db(conf_file)
    begin 
      File.open(conf_file) do |io|
        while line = io.gets 
          #logger.info(line)
          check_name, template_id = line.split(',')
          template_id = template_id.strip.chomp if template_id
#         logger.info(" #{template_id}")
          plugin = Plugin.new(name: check_name, checks_id: template_id)

          begin
            plugin.save
          rescue => e
            logger.error("update error when insert the checks name into db. == #{e}")
            return false
          end
        end
      end 
    rescue => e
      logger.error("open or read file error : #{e}")
      return false
    end

    true
  end

  def kill_process(name)
    process = `ps -ef | grep #{name} | grep -v 'grep'` # Get the arachni info 
    unless process.blank?
      pid = process.split(' ')          # Split the info , pid[1] is the pid
      `kill #{pid[1]}`
    end
  end

  # TODO 
  # When write the new checks in database error ,
  # we will rollback the database .
  def recover_plugin(plugin)
    plugin.each do |plug|
      p = Plugin.new(name:plug.name, checks_id: plug.checks_id)

      logger.info("p :#{p}")
      begin 
        p.save
      rescue => e
        logger.error("recover plugin error, #{e}")
        return
      end
    end
  end
end
