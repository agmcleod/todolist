# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_todolist_session',
  :secret      => '5d4042db577b49f677fe0f0d77f65fc57287842bab83b1398e82f102f29ff1302e1d0dd324a7c74b5dcdc35cfa07b56f0bd5722d9f0537ed2a70dff5de18c3e8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
