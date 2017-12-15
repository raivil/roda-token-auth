# Roda Token Authentication

Adds token authentication to Roda.
Based on [Roda Basic Auth](https://github.com/badosu/roda-basic-auth)

[![Gem Version](https://badge.fury.io/rb/roda-token-auth.svg)](https://badge.fury.io/rb/roda-token-auth)
[![Build Status](https://travis-ci.org/raivil/roda-token-auth.svg?branch=master)](https://travis-ci.org/raivil/roda-token-auth)
[![Maintainability](https://api.codeclimate.com/v1/badges/c27ee51a6ea057c86ab3/maintainability)](https://codeclimate.com/github/raivil/roda-token-auth/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/c27ee51a6ea057c86ab3/test_coverage)](https://codeclimate.com/github/raivil/roda-token-auth/test_coverage)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'roda-token-auth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install roda-token-auth

## Configuration

Configure your Roda application to use this plugin:

```ruby
plugin :token_auth
```

You can pass global options, in this context they'll be shared between all
`r.token_auth` calls.

```ruby
plugin :token_auth, authenticator: proc {|token, secret| [token, secret] == %w(foo bar)}
```

```ruby
plugin :token_auth, authenticator: proc {|token, secret| [token, secret] == %w(foo bar)}, token_variable: "X-My-Custom-Token", secret_variable: "X-My-Custom-Secret"
```

## Usage

Call `r.token_auth` inside the routes you want to authenticate the user, it will halt
the request with 401 response code if the authenticator is false.

You can specify the local authenticator with a block:

```ruby
r.token_auth { |token, secret| [token, secret] == %w(foo bar) }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/raivil/roda-token-auth.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
