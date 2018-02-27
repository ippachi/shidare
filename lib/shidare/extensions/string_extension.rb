require 'hanami/utils'

module Shidare
  module StringExtension
    refine String do
      def to_snake
        gsub(/([A-Z])/, '_\1')[1..-1].downcase
      end

      def to_camel
        split('_').map(&:capitalize).join
      end

      def pluralize
        Hanami::Utils::Inflector.pluralize(self)
      end
    end
  end
end
