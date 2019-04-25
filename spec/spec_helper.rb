ENV['RACK_ENV'] = 'test'

require 'bundler'
require_relative '../database/database'

Bundler.require

require_relative '../config/env'
require_relative '../app'
require 'capybara/rspec'

Capybara.app = App
Capybara.server = :webrick

Capybara.default_driver = :rack_test

Database.populate()
