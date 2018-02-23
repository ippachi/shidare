require "shidare/version"
require 'bcrypt'
require 'shidare/exceptions/exception'
require 'shidare/refinements/string_extension'

module Shidare
  using StringExtension

  module Registration
    def self.included(klass)
      entity = klass.to_s.slice(/.*(?=Registration)/).to_snake

      unless Object.const_get(entity.to_camel).schema.instance_variable_get(:@attributes).has_key?(:encrypted_password)
        raise AttributesError
      end

      define_method :signup_as do |user_params|
        registration_params = user_params.dup

        registration_params[:encrypted_password] = encrypted_password(user_params[:password])
        registration_params.delete(:password)

        unless Object.const_defined?("#{entity.to_camel}Repository")
          raise NotGenerateModel, "not generate #{entity.to_camel} model"
        end

        _repository(entity).new.create(registration_params)
      end

      klass.class_eval { private :signup_as }
    end

    private

    def _repository(entity)
      Object.const_get("#{entity.to_camel}Repository")
    end

    def encrypted_password(password)
      BCrypt::Password.create(password)
    end
  end
end
