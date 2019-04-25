require_relative '../database/database'

if ENV['RACK_ENV'] == 'test'
    puts 'testing environment'
    Database.db= SQLite3::Database.new ':memory:'
    Database.clear

end
