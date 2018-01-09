require 'hanami/model'

class User < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :email, Types::String
  end
end
