require 'socket'

module CassandraCQL

  module Binary

    class Transport

      def initialize(host, port)
        @socket = TCPSocket.new(host, port)
      end

      def send(operation, *message)
        puts "SEND #{operation} #{message.inspect}"
        opcode = OPERATIONS[operation.to_sym] unless operation.is_a?(Fixnum)
        @socket.sendmsg(RequestFrame.new(1, 0, 0, opcode, message.join).bytes)
      end

      def receive
        ResponseFrame.new(@socket).tap { |frame| puts "RECEIVE #{frame.inspect}" }
      end

    end

  end

end
