require 'hanami/model'
require 'hanami/model/migrator'
require 'hanami/model/sql'
require 'hanami/router'
require 'hanami/routes'
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

Hanami::Model.load!

class RouteMock
  def initialize
    router = Hanami::Router.new do
      root to: ->(_env) { [200, {}, ['root']] }
    end

    @routes = Hanami::Routes.new(router)
  end

  def method_missing(method_name, *_args)
    @routes.send(method_name)
  end
end
