require 'hanami/model'

module Shidare
  module RepositoryExtension
    refine Hanami::Repository do
      def by_email(email)
        send(self.class.relation).where(email: email).limit(1).one
      end
    end
  end
end
