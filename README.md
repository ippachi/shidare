# Shidare

Simple registration and session for Hanami

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shidare'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shidare

## Setting

You should make `shidare` directory into `lib`

```
lib
├── app
│   ├── entities
│   ├── mailers
│   ├── repositories
│   └── shidare
└── app.rb
```

And define `[model_name]Registration` into your `shidare` directory and include `Shidare::Registration`

example, `app/lib/shidare/user_registraion`

```ruby
module UserRegistration
  include Shidare::Registration
end
```

next include `UserRegistration` in your action.

example, `app/apps/web/controllers/users/create.rb`

```ruby
module Web::Controllers::Users
  class Create
    include Web::Action
    include UserRegistration

    def call(params)
    end
  end
end

```

## Usage

### Registration

**must**

Add `email`, `encrypted_password`, `activation_token` and `activated_at` column to your model.
and `activation_token` and `activated_at` is **NOT** null index.

example, `db/migrations/[date]_create_users.rb`

```ruby
Hanami::Model.migration do
  change do
    create_table :users do
      primary_key :id

      column :email             , String, null: false
      column :encrypted_password, String, null: false
      column :activation_token,   String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
      column :activated_at, DateTime
    end
  end
end

```

provide
- `#signup_as`
- `#activate_[model_name]`
- `#activated?`

#### signup_as

##### options
- `mail` (default is `false`)

Pass the `params`, so create record your into your model and activate.

```ruby
module Web::Controllers::Users
  class Create
    include Web::Action
    include UserRegistration

    def call(params)
      signup_as(params[:user]) # params -> { email: 'test@example.com', password: 'password', ... } 
    end
  end
end
```

If you pass the `mail: true`, you should define method `mailer` in your aciton class

```ruby
module Web::Controllers::Users
  class Create
    include Web::Action
    include UserRegistration

    def call(params)
      signup_as(params[:user], mail: true) # params -> { email: 'test@example.com', password: 'password', ... } 
    end
    
    private
    
    def mailer
      Mailers::Welcome
    end
  end
end
```

You can access entity attributes by `account` in your Mailer class

example `app/lib/mailers/welcome.rb`

```ruby
class Mailers::Welcome
  include Hanami::Mailer

  from    'noreply@exmaple.com'
  to      :recipient
  subject 'Hello'
  
  private
  
  def recipient
    account.email
  end
  
  def token
    account.activation_token
  end
end

```

#### activate_[model_name]

```ruby
module Web::Controllers::Users
  class AccountActivation
    include Web::Action
    include UserRegistration

    def call(params)
      acitivate_user(params) # params -> { email: 'user@example.com', activation_token: 'user_token' }
    end
  end
end
```

#### activated?

If record is activated return `true`

exmaple

```ruby
UserRepository.new.first.activated? # => true if user is activated
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/shidare. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Shidare project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/shidare/blob/master/CODE_OF_CONDUCT.md).
