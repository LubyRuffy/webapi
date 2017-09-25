require "pry-byebug"
require "sidekiq"
require 'json'

class SaveScanJob < ApplicationJob
  queue_as :default

  def perform(id)
    # Do something later
	scan = Scan.get_scan(id)
	if !scan || !scan.scan_id
		return
	end

	result = scan.get_data
	
	if result == true
		SaveScanJob.set(wait: 5.second).perform_later(id)
	end
  end
end
