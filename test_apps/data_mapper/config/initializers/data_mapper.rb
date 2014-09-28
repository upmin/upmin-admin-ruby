# If you want the logs displayed you have to do this before the call to setup
DataMapper::Logger.new($stdout, :debug) if Rails.env.development?

# An in-memory Sqlite3 connection:
DataMapper.setup(:default, "sqlite://#{::Rails.root}/db/test.sqlite3")

DataMapper::Property::String.length(255)

DataMapper.finalize
DataMapper.auto_upgrade!
