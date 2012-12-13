require 'rubygems'
require 'spork'

Spork.prefork do
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  ENV['DRB'] = 'true'

  require File.expand_path("../../config/environment", __FILE__)

  require 'rspec/rails'
  require 'capybara/rspec'
  require 'factory_girl_rails'

  Rails.backtrace_cleaner.remove_silencers!

  require 'database_cleaner'

  RSpec.configure do |config|
    config.mock_with :rspec
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.orm = "mongoid"
    end

    config.before(:each) do
      DatabaseCleaner.clean
    end

    config.include FactoryGirl::Syntax::Methods
  end

  Capybara.javascript_driver = :webkit
end

Spork.each_run do
  ActiveSupport::Dependencies.clear
  FactoryGirl.reload

  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
end

