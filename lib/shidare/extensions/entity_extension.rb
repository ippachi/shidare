require 'hanami/model'

module Shidare
  module EntityExtension
    refine Hanami::Entity.singleton_class do
      def column?(attribute_name)
        schema.instance_variable_get(:@attributes).key?(attribute_name)
      end

      def repository
        Object.const_get("#{self}Repository")
      end
    end
  end
end
