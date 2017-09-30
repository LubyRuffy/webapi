# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170930024952) do

  create_table "checks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diskchecks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "db_limit"
    t.integer "report_limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.string "url"
    t.string "vector_name"
    t.float "cvssv2", limit: 24
    t.integer "cwe"
    t.string "cwe_url"
    t.text "description"
    t.string "vector_type"
    t.string "http_method"
    t.text "tags"
    t.string "signature"
    t.string "seed"
    t.string "proof"
    t.text "response_body"
    t.boolean "requires_verification"
    t.text "references"
    t.text "remedy_code"
    t.text "remedy_guidance"
    t.text "remarks"
    t.string "severity"
    t.string "digest"
    t.boolean "false_positive"
    t.boolean "verified"
    t.text "verification_steps"
    t.text "remediation_steps"
    t.boolean "fixed"
    t.integer "scan_id"
    t.text "vector_inputs"
    t.text "vector_html"
    t.text "dom_transitions"
    t.text "dom_body"
    t.text "response"
    t.text "request"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "license_histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "license"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "licenses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "license"
    t.datetime "valid_time"
    t.datetime "activate_time"
    t.datetime "expired_time"
    t.boolean "activated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plugins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.integer "checks_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scans", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "type"
    t.boolean "active"
    t.boolean "extend_from_revision_sitemaps"
    t.boolean "restrict_to_revision_sitemaps"
    t.integer "instance_count"
    t.integer "dispatcher_id"
    t.string "instance_url"
    t.string "instance_token"
    t.string "scan_id"
    t.string "name"
    t.text "url"
    t.text "description"
    t.string "status"
    t.text "statistics"
    t.text "issue_digests"
    t.integer "owner_id"
    t.datetime "finished_at"
    t.integer "root_id"
    t.datetime "started_at"
    t.datetime "suspended_at"
    t.integer "schedule_id"
    t.boolean "load_balance"
    t.string "snapshot_path"
    t.integer "checks_id"
    t.boolean "login_setting"
    t.integer "login_type"
    t.string "login_url"
    t.string "http_authentication_username"
    t.string "http_authentication_password"
    t.text "http_cookies"
    t.text "http_user_agent"
    t.boolean "spider_setting"
    t.integer "scope_directory_depth_limit"
    t.integer "scope_page_limit"
    t.text "scope_exclude_path_patterns"
    t.text "scope_exclude_content_patterns"
    t.text "scope_extend_paths"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "serials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "serial"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "sitemaps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "scan_id"
    t.text "sitemap"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.text "checks"
    t.integer "ref"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "username"
    t.string "password"
    t.string "email"
    t.string "phone_no"
    t.text "description"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
