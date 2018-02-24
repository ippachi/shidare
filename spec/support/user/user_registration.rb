require 'hanami/controller'
require 'hanami/action'

module UserRegistration
  include Shidare::Registration
end

class SignupAs
  include Hanami::Action
  include UserRegistration

  def call(params)
    signup_as(params[:user])
  end
end
