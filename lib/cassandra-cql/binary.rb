require 'cassandra-cql'
require 'cassandra-cql/binary/client'
require 'cassandra-cql/binary/frame'
require 'cassandra-cql/binary/message'
require 'cassandra-cql/binary/request_frame'
require 'cassandra-cql/binary/response'
require 'cassandra-cql/binary/response_frame'
require 'cassandra-cql/binary/transport'

module CassandraCQL

  def self.cassandra_version
    'binary'
  end

  module Binary

    class ServerError < StandardError

      attr_reader :code

      def initialize(message, code)
        super(message)
        @code = code
      end

    end

    OPERATIONS = {
      :error => 0,
      :startup => 1,
      :ready => 2,
      :authenticate => 3,
      :credentials => 4,
      :options => 5,
      :supported => 6,
      :query => 7,
      :result => 8,
      :prepare => 9,
      :execute => 10,
      :register => 11,
      :event => 12
    }

    CODES = OPERATIONS.invert

  end

end

require "#{File.expand_path(File.dirname(__FILE__))}/../cassandra-cql"
