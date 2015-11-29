require 'dry/data/type/optional'
require 'dry/data/type/hash'
require 'dry/data/type/array'

require 'dry/data/sum_type'

module Dry
  module Data
    class Type
      attr_reader :constructor

      attr_reader :primitive

      def self.[](primitive)
        if primitive == ::Array
          Type::Array
        elsif primitive == ::Hash
          Type::Hash
        else
          Type
        end
      end

      def self.strict_constructor(primitive, input)
        if input.is_a?(primitive)
          input
        else
          raise TypeError, "#{input.inspect} has invalid type"
        end
      end

      def self.passthrough_constructor(input)
        input
      end

      def initialize(constructor, primitive)
        @constructor = constructor
        @primitive = primitive
      end

      def name
        primitive.name
      end

      def call(input)
        constructor[input]
      end
      alias_method :[], :call

      def valid?(input)
        input.is_a?(primitive)
      end

      def |(other)
        Data.SumType(self, other)
      end
    end
  end
end
