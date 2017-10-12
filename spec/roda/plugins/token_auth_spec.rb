require File.expand_path("../../spec_helper", File.dirname(__FILE__))

RSpec.describe Roda::RodaPlugins::TokenAuth do
  include Rack::Test::Methods

  attr_accessor :app
  def roda
    app = Class.new(Roda)
    yield app
    self.app = app
  end

  def app_root(*opts, &block)
    app.route do |r|
      r.root do
        r.token_auth(*opts, &block)
        "I am GROOT!"
      end
    end
  end

  it "has a version number" do
    expect(Roda::RodaPlugins::TokenAuth::VERSION).not_to be nil
  end

  describe "local authenticator" do
    before do
      roda do |r|
        r.plugin :token_auth, authenticator: ->(token, secret) { [token, secret] == %w[foo bar] }
      end
      app_root { |u, p| [u, p] == %w[baz inga] }
    end
    context "correct credentials" do
      it "returns correct body" do
        header "X-Token", "baz"
        header "X-Secret", "inga"
        get "/"
        expect(last_response.body).to eq("I am GROOT!")
      end
      it "is successful" do
        header "X-Token", "baz"
        header "X-Secret", "inga"
        get "/"
        expect(last_response.status).to eq(200)
      end
    end
    context "invalid credentials" do
      it "returns 401" do
        header "X-Token", "foo"
        header "X-Secret", "bar"
        get "/"
        expect(last_response.status).to eq(401)
      end
      it "returns 401" do
        header "X-Token", "foo"
        header "X-Secret", "bar"
        get "/"
        expect(last_response.body).to eq({ errors: "Invalid Credentials", success: false}.to_json)
      end
      context " custom unauth body" do
        before do
          roda do |r|
            r.plugin :token_auth, authenticator: ->(token, secret) { [token, secret] == %w[foo bar] },
                                  unauthorized_body: proc { { errors: "Custom Message", custom_param: false} }
          end
          app_root { |u, p| [u, p] == %w[baz inga] }
        end
        context "correct credentials" do
          it "returns correct body" do
            header "X-Token", "foo"
            header "X-Secret", "bar"
            get "/"
            expect(last_response.body).to eq({ errors: "Custom Message", custom_param: false}.to_json)
          end
        end
      end
      context "no credentials" do
        it "returns 401" do
          get "/"
          expect(last_response.status).to eq(401)
        end
      end
    end
  end

  describe "global authenticator" do
    before do
      roda { |r| r.plugin :token_auth, authenticator: ->(token, secret) { [token, secret] == %w[foo bar] } }
      app_root
    end
    context "correct credentials" do
      it "returns correct body" do
        header "X-Token", "foo"
        header "X-Secret", "bar"
        get "/"
        expect(last_response.body).to eq("I am GROOT!")
      end
      it "is successful" do
        header "X-Token", "foo"
        header "X-Secret", "bar"
        get "/"
        expect(last_response.status).to eq(200)
      end
    end
    context "invalid credentials" do
      it "returns 401" do
        header "X-Token", "baz"
        header "X-Secret", "inga"
        get "/"
        expect(last_response.status).to eq(401)
      end
      context "no credentials" do
        it "returns 401" do
          get "/"
          expect(last_response.status).to eq(401)
        end
      end
    end
  end

  describe "invalid configs" do
    before do
      roda { |r| r.plugin :token_auth }
      app_root
    end
    context "no authenticator" do
      it "raises config error" do
        expect { get "/" }.to raise_error(RuntimeError, /Must provide an authenticator block/)
      end
    end
  end
end
