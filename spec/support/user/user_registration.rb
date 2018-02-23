require 'hanami/controller'
require 'hanami/action'
require 'hanami/router'

module UserRegistration
  include Shidare::Registration
end

app = Hanami::Router.new do
  root to: ->(env) { [200, {}, ['root']] }
end

class SignupAs
  include Hanami::Action
  include UserRegistration

  def call(params)
    signup_as(params[:user])
  end
end
