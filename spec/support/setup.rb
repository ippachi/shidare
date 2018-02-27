require 'hanami/model'
require 'hanami/model/migrator'
require 'hanami/model/sql'
require 'hanami/mailer'
require 'hanami/utils'
require 'pry'
require 'pg'

system 'dropdb shidare_test'
system 'createdb shidare_test'

Hanami::Model.configure do
  adapter       :sql, 'postgres://localhost/shidare_test'
  migrations    Dir.pwd + '/spec/support/fixtures/migrations'
  schema        Dir.pwd + '/tmp/schema.sql'

  gateway do |g|
    g.connection.extension(:pg_enum)
  end
end

Hanami::Model::Migrator.migrate

class User < Hanami::Entity
end

class UserRepository < Hanami::Repository
end

class People < Hanami::Entity
end

class PeopleRepository < Hanami::Repository
end

class Admin < Hanami::Entity
end

class AdminRepository < Hanami::Repository
end

require 'shidare'

Hanami::Model.load!

Hanami::Mailer.configure do
  root Pathname.new __dir__ + '/fixtures/templates'
end

Hanami::Mailer.class_eval do
  def self.reset!
    self.configuration = configuration.duplicate
    configuration.reset!
  end
end

Hanami::Mailer::Dsl.class_eval do
  def reset!
    @tempaltes = {}
  end
end

Hanami::Utils.require!('spec/support')

Hanami::Mailer.configure do
  root __dir__ + '/fixtures'
  delivery_method :test
end.load!

class AccountActivation
  include Hanami::Mailer

  from    'noreply@example.com'
  to      :recipient
  subject :subject

  private

  def recipient
    account.email
  end

  def subject; end

  def token
    account.activation_token
  end
end

AccountActivation.templates
