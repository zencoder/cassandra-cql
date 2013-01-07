if RUBY_VERSION >= "1.9"
  require 'simplecov'
  SimpleCov.start
end

require 'rubygems'
require 'yaml'
require 'rspec'

CASSANDRA_VERSION = ENV['CASSANDRA_VERSION'] || '1.2' unless defined?(CASSANDRA_VERSION)

$LOAD_PATH << "#{File.expand_path(File.dirname(__FILE__))}/../lib"
if ENV['CASSANDRA_CQL_PROTOCOL'] == 'binary'
  require 'cassandra-cql/binary'
else
  require "cassandra-cql/#{CASSANDRA_VERSION}"
end

def yaml_fixture(file)
  if file.kind_of?(Symbol)
    file = "#{file}.yaml"
  elsif file !~ /\.yaml$/
    file = "#{file}.yaml"
  end
  YAML::load_file(File.dirname(__FILE__) + "/fixtures/#{file}")
end

def setup_cassandra_connection
  options = {}
  host = ENV['CASSANDRA_CQL_HOST']
  if ENV['CASSANDRA_CQL_PROTOCOL'] == 'binary'
    options[:protocol] = :binary
    host ||= '127.0.0.1:9042'
  else
    host ||= '127.0.0.1:9160'
  end
  connection = CassandraCQL::Database.new([host], options, :retries => 5, :timeout => 1)
  if !connection.keyspaces.map(&:name).include?("CassandraCQLTestKeyspace")
    connection.execute("CREATE KEYSPACE CassandraCQLTestKeyspace WITH strategy_class='org.apache.cassandra.locator.SimpleStrategy' AND strategy_options:replication_factor=1")
  end
  connection.execute("USE CassandraCQLTestKeyspace")

  connection
end
