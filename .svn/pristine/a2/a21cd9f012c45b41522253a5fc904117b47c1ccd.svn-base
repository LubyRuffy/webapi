class CreateScans < ActiveRecord::Migration[5.1]
  def change
    create_table :scans do |t|
      t.string :type
      t.boolean :active
      t.boolean :extend_from_revision_sitemaps
      t.boolean :restrict_to_revision_sitemaps
      t.integer :instance_count
      t.integer :dispatcher_id
      t.string :instance_url
      t.string :instance_token
      t.string :scan_id
      t.string :name
      t.text :url
      t.text :description
      t.string :status
      t.text :statistics
      t.text :issue_digests
      t.integer :owner_id
      t.datetime :finished_at
      t.integer :root_id
      t.datetime :started_at
      t.datetime :suspended_at
      t.integer :schedule_id
      t.boolean :load_balance
      t.string :snapshot_path
      t.integer :checks_id
      t.boolean :login_setting
      t.integer :login_type
      t.string :login_url
      t.string :http_authentication_username
      t.string :http_authentication_password
      t.text :http_cookies
      t.text :http_user_agent
      t.boolean :spider_setting
      t.integer :scope_directory_depth_limit
      t.integer :scope_page_limit
      t.text :scope_exclude_path_patterns
      t.text :scope_exclude_content_patterns
      t.text :scope_extend_paths

      t.timestamps
    end
  end
end
