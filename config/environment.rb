# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do
  config.gem "cucumber-rails", :lib => "cucumber/rails"
end
