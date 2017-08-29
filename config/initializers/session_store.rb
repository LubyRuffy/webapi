
#Rails.application.config.session_store :cache_store, key: '_webscan_api_key'
# Be sure to restart your server when you modify this file.
#Rails.application.config.session_store :cache_store, key: '_webscan_session'
#Rails.application.config.session_store :active_record_store, :key => '_webapi_session', :expire_after => 5.minutes
#Rails.application.config.session_store :active_record_store, :key => '_webapi_session', :expire_after => 5.minutes

#Rails.application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 60.minutes
Rails.application.config.session_store ActionDispatch::Session::CacheStore, :expire_in => 30.minutes
