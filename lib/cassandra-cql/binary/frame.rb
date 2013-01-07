module CassandraCQL

  module Binary

    class Frame

      attr_reader :version, :flags, :stream, :opcode

      def initialize(version, flags, stream, opcode)
        @version, @flags, @stream, @opcode =
          version, flags, stream, opcode
      end

      def operation
        CODES[@opcode]
      end

      def inspect
        "#<#{self.class.name}:#{operation.upcase}".tap do |str|
          str << " #{message.inspect}" if message
          str << ">"
        end
      end

    end

  end

end
