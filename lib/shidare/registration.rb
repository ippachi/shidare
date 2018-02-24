require 'shidare/version'
require 'bcrypt'
require 'shidare/exceptions/attributes_error'
require 'shidare/exceptions/model_not_generated_error'
require 'shidare/extensions/string_extension'
require 'shidare/extensions/entity_extension'

module Shidare
  module Registration
    using StringExtension
    using EntityExtension

    def self.included(klass)
      entity_name = klass.to_s.slice(/.*(?=Registration)/)
      raise ModelNotGenerated unless Object.const_defined?(entity_name)
      entity = Object.const_get(entity_name.to_camel)
      raise AttributesError unless entity.column?(:encrypted_password)

      define_method :signup_as do |params|
        entity.repository.new.create(formated_params(params))
      end
    end

    private

    def encrypted_password(password)
      BCrypt::Password.create(password)
    end

    def formated_params(params)
      submit_params = params.dup

      submit_params[:encrypted_password] \
        = encrypted_password(params[:password])

      submit_params.tap { |param| param.delete(:password) }
    end
  end
end
