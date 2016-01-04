$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

begin
  require 'rails'
rescue LoadError
end

require 'bundler/setup'
Bundler.require

require 'minitest/autorun'
require 'capybara/dsl'
require 'database_cleaner'

# Simulate a gem providing a subclass of ActiveRecord::Base before the Railtie is loaded.
require 'fake_gem' if defined? ActiveRecord

require 'fake_app/rails_app'      if defined? Rails
require 'spec_helper_for_sinatra' if defined? Sinatra

Capybara.app = Rails.application

Minitest::Test.include Module.new {
  extend ActiveSupport::Concern

  module ClassMethods
    def inherited(kls)
      super
      kls.prepend SetupDatabaseCleaner
    end
  end
}

module SetupDatabaseCleaner
  def setup
    DatabaseCleaner.start
    super
  end

  def teardown
    super
    DatabaseCleaner.clean
  end
end

DatabaseCleaner[:active_record].strategy = :transaction if defined? ActiveRecord
DatabaseCleaner[:mongoid].strategy = :truncation if defined? Mongoid

DatabaseCleaner.clean_with :truncation if defined?(ActiveRecord) || defined?(Mongoid)
