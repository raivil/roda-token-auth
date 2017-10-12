# frozen_string_literal: true
require "roda"
require "roda/plugins/token_auth/version"
require "json"

module Roda::RodaPlugins
  module TokenAuth
    DEFAULTS = {
      token_variable: "X-Token",
      secret_variable: "X-Secret",
      unauthorized_headers: proc do |_opts|
        { "Content-Type" => "application/json" }
      end,
      unauthorized_body: proc do |_opts|
        { errors: "Invalid Credentials", success: false}
      end
    }.freeze

    def self.configure(app, opts = {})
      plugin_opts = (app.opts[:token_auth] ||= DEFAULTS)
      app.opts[:token_auth] = plugin_opts.merge(opts)
      app.opts[:token_auth].freeze
    end

    module RequestMethods
      def token_auth(opts = {}, &authenticator)
        auth_opts = roda_class.opts[:token_auth].merge(opts)
        authenticator ||= auth_opts[:authenticator]

        raise "Must provide an authenticator block" if authenticator.nil?
        auth_token = header_variable(auth_opts, :token_variable)
        auth_secret = header_variable(auth_opts, :secret_variable)
        return if authenticator.call(auth_token, auth_secret)
        auth_opts[:unauthorized]&.call(self)
        halt [401,
              auth_opts[:unauthorized_headers].call(auth_opts),
              [auth_opts[:unauthorized_body].call(auth_opts).to_json]]
      end

      def header_variable(auth_opts, variable_name)
        env["HTTP_#{auth_opts[variable_name]}".tr("-", "_").upcase]
      end
    end
  end

  register_plugin(:token_auth, TokenAuth)
end
