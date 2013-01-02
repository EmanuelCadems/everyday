# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  
  Capybara.run_server = true #Whether start server when testing
  # Capybara.server_port = 8200
  Capybara.server_port = 8200
  Capybara.app_host = "http://localhost:8200"
  Capybara.default_selector = :css #:xpath #default selector , you can change to :css
  Capybara.default_wait_time = 5 #When we testing AJAX, we can set a default wait time
  Capybara.ignore_hidden_elements = false #Ignore hidden elements when testing, make helpful when you hide or show elements using javascript
  Capybara.javascript_driver = :selenium #default driver when you using @javascript tag
  # Other option is:
  # Capybara.javascript_driver = :webkit
  # config.before :each do
  #   if Capybara.current_driver eq :selenium
  #     DatabaseCleaner.strategy = :truncation
  #   else
  #     DatabaseCleaner.strategy = :transaction
  #   end
  #   DatabaseCleaner.start
  # end

  # config.after(:each) do
  #   DatabaseCleaner.clean
  # end


  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.include FactoryGirl::Syntax::Methods
  config.include LoginMacros


end
