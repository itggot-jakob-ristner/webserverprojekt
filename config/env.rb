require_relative '../database/database'

if ENV['RACK_ENV'] == 'test'
    puts 'gay environment'
    Database.db= SQLite3::Database.new ':memory:'
    Database.clear

end
