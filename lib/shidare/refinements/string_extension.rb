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
end

