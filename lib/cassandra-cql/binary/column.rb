module CassandraCQL

  module Binary

    class Column

      attr_reader :keyspace, :table, :name, :type

      def initialize(keyspace, table, name, type)
        @keyspace, @table, @name, @type =
          keyspace, table, name, type
      end

    end

  end

end
