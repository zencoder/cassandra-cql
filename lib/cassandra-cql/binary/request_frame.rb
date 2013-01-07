require 'cassandra-cql/binary/frame'

module CassandraCQL

  module Binary

    class RequestFrame < Frame

      attr_reader :message

      def initialize(version, flags, stream, opcode, message)
        super(version, flags, stream, opcode)
        @message = message
      end

      def bytes
        length = @message.bytesize
        [
          @version, @flags, @stream, @opcode,
          length,
          @message
        ].pack("C4NA*")
      end

    end

  end

end
