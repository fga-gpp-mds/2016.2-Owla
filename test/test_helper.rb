ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  def sign_in_as(member)
    post '/login/', params: {session: { email: member.email, password: member.password } }
  end

  def sign_out_as(member)
  	get '/logout/', params: {session: { email: member.email, password: member.password } }
  end
  # Add more helper methods to be used by all tests here...
end
