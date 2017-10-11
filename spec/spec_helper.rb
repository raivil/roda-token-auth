require "bundler/setup"
require "roda/plugins/token_auth"

require "rack/test"
RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

#
# def app_root(*opts, &block)
#   app.route do |r|
#     r.root do
#       r.basic_auth(*opts, &block)
#
#       "I am ROOT!"
#     end
#   end
# end
#
# def roda
#   app = Class.new(Roda)
#
#   yield app
#
#   self.app = app
# end
#
# def assert_authorized
#   assert_equal 200, last_response.status
#   assert_equal "I am ROOT!", last_response.body
# end
#
# def assert_unauthorized(realm: app.opts[:basic_auth][:realm])
#   assert_equal 401, last_response.status
#   assert_equal "Basic realm=\"#{realm}\"", last_response['WWW-Authenticate']
# end
# end
