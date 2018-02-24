require 'hanami/model'
require 'hanami/model/migrator'
require 'hanami/model/sql'
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

Hanami::Model.load!
