require 'active_record'
require 'pry'

ActiveRecord::Base.logger = Logger.new(STDERR)

require './db_config'
require './models/bit'
require './models/category'
require './models/user'
require './models/like'


binding.pry