require 'hanami/controller'
require 'hanami/action/session'
require 'shidare'

class Login
  include Hanami::Action
  include Hanami::Action::Session
  include Shidare::Authentication

  def call(params)
    user = User.new(params)
    login_as(user)
  end
end

