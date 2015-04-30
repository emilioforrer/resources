#ENV["RAILS_ENV"] ||= 'test'
require 'database_cleaner'
require 'factory_girl'
require 'faker'

require File.expand_path("../../test/dummy/config/environment", __FILE__)
Dir.glob(File.expand_path("factories/*.rb", __FILE__)).each { |f| require f.gsub(".rb","") }



RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    begin
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
      #FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end

FactoryGirl.find_definitions
