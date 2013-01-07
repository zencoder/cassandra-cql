module CassandraCQL

  module Binary

    class Row

      attr_reader :columns, :values

      def initialize(columns, values)
        @columns, @values = columns, values
      end

      def each_column_with_value(&block)
        @columns.zip(@values, &block)
      end

      def each_pair
        each_column_with_value do |column, value|
          yield column.name, value
        end
      end

      def to_hash
        {}.tap do |hash|
          each_pair { |column, value| hash[column] = value }
        end
      end

      def inspect
        "#<#{self.class.name}: #{to_hash.inspect}>"
      end

    end

  end

end
