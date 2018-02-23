require "shidare/version"
require 'bcrypt'
require 'hanami/controller'
require 'hanami/model'
require 'hanami/router'

module Shidare
  module StringExtension
    refine String do
      def to_snake
        self.gsub(/([A-Z])/, '_\1')[1..-1].downcase
      end

      def to_camel
        self.split('_').map(&:capitalize).join
      end
    end
  end

  using StringExtension

  module Registration
    def self.included(klass)
      entity = klass.to_s.slice(/.*(?=Registration)/).to_snake

      define_method :signup_as do |user_params|
        registration_params = user_params.dup

        registration_params[:encrypted_password] = encrypted_password(user_params[:password])
        registration_params.delete(:password)

        unless Object.const_defined?("#{entity.to_camel}Repository")
          raise NotGenerateModel, "not generate #{entity.to_camel} model"
        end

        _repository(entity).new.create(registration_params)
      end

      def _repository(entity)
        Object.const_get("#{entity.to_camel}Repository")
      end

      def encrypted_password(password)
        BCrypt::Password.create(password)
      end

      klass.class_eval { private :signup_as }

    end

    private

    def after_signup_path
      redirect_to routes.root_path
    end
  end
end
