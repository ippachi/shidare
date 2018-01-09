require "shidare/version"
require 'bcrypt'
require 'hanami/controller'
require 'hanami/action/session'

module Shidare
  class Authentication
    include Hanami::Action
    include Hanami::Action::Session
    def self.inherited(klass)
      entity_name = klass.to_s.gsub(/Authentication/, '').downcase
      klass.class_eval do
        define_method("current_#{entity_name}") do
          Object.const_get("#{entity_name.capitalize}Repository").new.find(session["#{entity_name}_id".to_sym])
        end

      end
    end

    def initialize(session)
      @session = session
    end

    def login(id)
      @session[:current_id] = id
    end


    def logout
      @session[:current_id] = nil
    end

    def signed_in?
      @session["current_id"] ? true : false
    end
  end
end
