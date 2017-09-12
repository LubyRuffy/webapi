module DiskMonitor

  def get_disk_size
    du_cmd = `du -s /var/log/` # The smallest unit is Kb. eg. 200 /var/log/ 
    size = du_cmd.split
    return size[0]
  end

end
