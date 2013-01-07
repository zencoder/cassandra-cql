require 'cassandra-cql/binary/frame'
require 'cassandra-cql/binary/column'
require 'cassandra-cql/binary/row'

module CassandraCQL

  module Binary

    class Response

      def self.build(frame)
        response_type =
          case frame.opcode
          when 0
            code = Message::Int.read(frame)
            message = Message::String.read(frame)
            raise ServerError.new(message, code)
          when 2 then Ready
          when 3 then Authenticate
          when 6 then Supported
          when 8
            result_type = frame.read(4).unpack('N').first
            case result_type
            when 1 then nil # void
            when 2 then Rows
            when 3 then SetKeyspace
            when 4 then Prepared
            when 5 then SchemaChange
            else raise "Unrecognized result type #{result_type}"
            end
          when 12 then Event
          else raise "Unrecognized response type #{response_type}"
          end
        response_type.new(frame) if response_type
      end

      def initialize(frame)
      end

    end

    class Result < Response
    end

    class SchemaChange < Response
      # TODO
    end

    class Ready < Response
      #TODO
    end

    class Rows < Result

      def initialize(frame)
        @flags = Message::Int.read(frame)
        @columns_count = Message::Int.read(frame)
        global_tables_spec = @flags & 1 != 0
        if global_tables_spec
          @keyspace = Message::String.read(frame)
          @table = Message::String.read(frame)
        end
        @columns = @columns_count.times.map do
          if !global_tables_spec
            keyspace = Message::String.read(frame)
            table = Message::String.read(frame)
          else
            keyspace = @keyspace
            table = @table
          end
          Column.new(
            keyspace,
            table,
            Message::String.read(frame),
            Message::Option.read(frame)
          )
        end
        @rows_count = Message::Int.read(frame)
        @rows = @rows_count.times.map do
          Row.new(
            @columns,
            @columns_count.times.map { Message::Bytes.read(frame) }
          )
        end
      end

    end

    class SetKeyspace < Result

      def initialize(frame)
        @keyspace = Message::String.read(frame)
      end

    end

  end

end
