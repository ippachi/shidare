require 'hanami/controller'
require 'hanami/action/session'
require 'shidare'

class Logout
  include Hanami::Action
  include Hanami::Action::Session
  include Shidare::Authentication

  def call(params)
    user = User.new(params)
    logout_from(user)
  end
end
