require 'hanami/controller'
require 'hanami/action/session'
require 'shidare'

class CurrentUser
  include Hanami::Action
  include Hanami::Action::Session
  include Shidare::Authentication

  expose :user

  def call(params)
    user = User.new(params)
    login_as(user)
    @user = current_user
  end
end
