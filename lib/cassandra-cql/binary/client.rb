module CassandraCQL

  module Binary

    class Client

      attr_reader :transport

      def initialize(server, cql_version = nil)
        host, port = server.split(':', 2)
        cql_version ||= '3.0.0'
        @transport = Transport.new(host, port.to_i)
        @cql_version = cql_version
      end

      def startup
        @transport.send(
          :startup, Message::StringMap.encode('cql_version' => @cql_version)
        )
        response_frame = @transport.receive
        Response.build(response_frame)
      end

      def execute_cql_query(query, compression = nil) #TODO handle compression
        @transport.send(
          :query,
          Message::LongString.encode(query),
          Message::Consistency::QUORUM #XXX why is this necessary? isn't it specified in the query?
        )
        Response.build(@transport.receive)
      end

    end

  end

end
