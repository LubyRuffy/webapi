module MysqlMonitor
  require 'mysql2'

  def connect_mysql
    config = {}

    config[:host] = '127.0.0.1'
    config[:username] = 'venus'
    config[:password] = 'venus70'
    config[:database] = 'information_schema'
#    config[:encoding] = 'utf-8'

    begin
      client = Mysql2::Client.new(config)
    rescue => ex 
      puts "Mysql connect error" 
      fail ex
    end

    client
  end

  def close_mysql(client)
    client.close if client
  end

  def get_db_size()
    db = connect_mysql
    query_cmd = "select concat(round(sum(DATA_LENGTH/1024),2)) as data from TABLES"

    if !db
      return 0
    end
    
    begin
      results = db.query(query_cmd)
    rescue Mysql::Error => e 
      puts "mysql error #{e}"
      #logger.info("-------------mysql error #{e}")
    end

    #logger.info("query results is #{results}")

    size = 0

    results.each do |row|
      size = row["data"]
    end

    close_mysql(db)

    size
  end
end
