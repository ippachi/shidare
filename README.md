# Shidare

Simple sessoin for hanami by bcrypt

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shidare'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shidare

## Usage

Include your controller like below

```ruby
module Web::controllers::Users
  class Create
    include Web::Action
    include Shidare::Authentication
    
    def call(params)
    end
  end
end
```
## interface
you can use below methods

- login_as
- logout_from
- current_user
- sigend_in?

## deteil description about above methods

### login_as

```ruby
login_as(UserRepository.new.first)
```

then current_user(:user) will return current login user

### logout_from

```ruby
logout_from(:user)
```

then logout current login user and current_user(:user) will return nil

### current_user

```ruby
current_user(:user)
```

then return current login user entity

### signed_in?

```ruby
signed_in(:user)
```

then return true if login as user

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/shidare. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Shidare project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/shidare/blob/master/CODE_OF_CONDUCT.md).
