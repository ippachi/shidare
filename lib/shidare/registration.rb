require 'shidare/version'
require 'bcrypt'
require 'securerandom'

require 'shidare/exceptions/attributes_error'
require 'shidare/exceptions/model_not_generated_error'

require 'shidare/extensions/string_extension'
require 'shidare/extensions/entity_extension'
require 'shidare/extensions/repository_extension'

module Shidare
  module Registration
    using StringExtension
    using EntityExtension
    using RepositoryExtension

    class << self
      def included(klass)
        klass.class_eval do
          entity = Object.const_get(klass.to_s.slice(/.*(?=Registration)/).to_camel)

          entity.class_eval do
            # Return entity is acitavated or not
            #
            # example:
            # user = UserRepository.new.first
            # user.activated?
            #
            # @return [Boolean] if entity is activated, return true
            def activated?
              !!activated_at
            end
          end

          # Signup by parameters
          #
          # If you want to signup as paramger {name, email, password}
          # use like below
          # example:
          # signup_as({ name: 'ippachi', email: 'test@example.com', password: 'password' })
          #
          # @param  params [Hash]     parameter you want to signup
          # @param  mail   [Boolean]  if you use mail activation, set true
          #
          # @return [Entity]   signuped entity
          define_method :signup_as do |params, mail: false|
            define_signup_as(entity, params, mail)
          end

          # Activate specific entity by email and activation_token
          #
          # example:
          # activate_user( { email: 'test@example.com', activation_token: 'example_token' } )
          #
          # @params params [Hash]   parameter that has email and activation_token keys
          #
          # @return [Boolean] return false if account don't have specific email
          define_method "activate_#{entity.to_s.to_snake}" do |params|
            define_activate(entity, params)
          end
        end
      end
    end

    private

    # Return encrypted password by BCrypt
    #
    # @param password [String] password
    #
    # @return [String] encrypted string
    def encrypted_password(password)
      BCrypt::Password.create(password)
    end

    # Format params into suitable form for signup
    #
    # example:
    # UserRepository.new.create(formated_params({ email: 'test@example.com', password: 'password' }))
    #
    # @param params [Hash]    parameter that is using for signup
    # @param mail   [Boolean] set true, if you use mail activation
    def formated_params(params, mail)
      submit_params = params.dup

      submit_params[:encrypted_password] \
        = encrypted_password(params[:password])

      if mail
        submit_params[:activation_token] = token
      else
        submit_params[:activated_at] = Time.now
      end

      submit_params.tap { |param| param.delete(:password) }
    end

    # Return urlsafe token for account activation
    #
    # @return [String] token
    def token
      SecureRandom.urlsafe_base64
    end

    def define_signup_as(entity, params, mail)
      raise AttributesError unless entity.column?(:encrypted_password)
      if mail
        raise AttributesError unless entity.activatable?
      end
      account = entity.repository.new.create(formated_params(params, mail))
      mailer.deliver(account: account) if mail
      account
    end

    def define_activate(entity, params)
      account = entity.repository.new.by_email(params[:email])
      return nil unless account && account.activation_token == params[:activation_token]
      entity.repository.new.update(account.id, acitvation_token: nil, activated_at: Time.now)
    end

    def mailer; end
  end
end
