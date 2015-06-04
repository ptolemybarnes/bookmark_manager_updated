require 'data_mapper'

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_test")

require './app/models/link'
require './app/models/tag'

DataMapper.finalize

DataMapper.auto_upgrade!
