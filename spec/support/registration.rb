require 'hanami/controller'
require 'hanami/action'
require 'pry'

module UserRegistration
  include Shidare::Registration
end

module AdminRegistration
  include Shidare::Registration
end

module PeopleRegistration
  include Shidare::Registration
end

class SignupAs
  include Hanami::Action
  include UserRegistration

  def call(params)
    signup_as(params[:user])
  end
end

class SignupAsWithMail
  include Hanami::Action
  include AdminRegistration

  def call(params)
    signup_as(params[:admin], mail: true)
  end

  private

  def mailer
    AccountActivation
  end
end

class InvalidModel
  include Hanami::Action
  include PeopleRegistration

  def call(params)
    signup_as(params[:people])
  end
end

class Activation
  include Hanami::Action
  include AdminRegistration

  def call(params)
    activate_admin(params)
  end
end
