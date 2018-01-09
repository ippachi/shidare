require "shidare/version"
require 'bcrypt'
require 'hanami/controller'
require 'hanami/action/session'

module Shidare
  module Authentication
    private
    def login_as(user)
      session["#{user.class.to_s.downcase}_id".to_sym] = user.id
    end

    def logout_from(user)
      session["#{user}_id".to_sym] = nil
    end

    def current_user(user)
      Object.const_get("#{user.capitalize}Repository").new.find(session["#{user}_id".to_sym])
    end
  end
end
