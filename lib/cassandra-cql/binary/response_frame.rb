require 'stringio'
require 'cassandra-cql/binary/frame'

module CassandraCQL

  module Binary

    class ResponseFrame < Frame

      attr_reader :length

      def initialize(socket)
        version, flags, stream, opcode, length =
          socket.recv(8).unpack('C4N')
        super(version, flags, stream, opcode)
        @length = length
        if length > 0
          @body = StringIO.new(socket.recv(length))
        else
          @body = StringIO.new
        end
      end

      def read(bytes)
        @body.read(bytes)
      end

      def message
        @body.string
      end

    end

  end

end
