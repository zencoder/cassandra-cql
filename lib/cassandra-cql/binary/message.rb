module CassandraCQL

  module Binary

    module Message

      class Int

        def self.encode(value)
          [value].pack('l>')
        end

        def self.read(io)
          io.read(4).unpack('l>').first
        end

      end

      class Short

        def self.encode(value)
          [value].pack('s>')
        end

        def self.read(io)
          io.read(2).unpack('s>').first
        end

      end

      class String

        def self.encode(value)
          "#{Short.encode(value.to_s.bytesize)}#{value}"
        end

        def self.read(io)
          io.read(Short.read(io))
        end

      end

      class LongString

        def self.encode(value)
          "#{Int.encode(value.to_s.bytesize)}#{value}"
        end

        def self.read(io)
          io.read(Int.read(io))
        end

      end

      class StringList

        def self.encode(values)
          "#{Short.encode(values.length)}#{values.map { String.encode(value) }.join}"
        end

        def self.read(io)
          Short.read(io).times.map { String.read(io) }
        end

      end

      class Bytes

        def self.encode(bytes)
          "#{Int.encode(bytes.bytesize)}#{bytes}"
        end

        def self.read(io)
          length = Int.read(io)
          puts length
          return if length < 0
          io.read(length)
        end

      end

      class ShortBytes

        def self.encode(bytes)
          "#{Short.encode(bytes.bytesize)}#{bytes}"
        end

        def self.read(io)
          io.read(Short.read(io))
        end

      end

      class Option

        def self.encode(id, value)
          "#{Short.encode(id)}#{value}"
        end

        def self.read(io)
          Short.read(io)
        end

      end

      class OptionList

        def self.encode(options)
          "#{Short.encode(options.length)}#{options.each_pair.map { |id, value| Option.encode(id, value) }.join}"
        end

        def self.read(io, value_type)
          raise "Not implemented" # FIXME I don't understand this options thing yet
        end

      end

      class Inet

        def self.encode(host, port)
          #TODO support IPV6
          host_bytes = host.split('.').map { |part| part.to_i }
          "#{[host_bytes.length, *host_bytes].pack('C5')}#{Int.encode(port)}"
        end

        def self.read(io)
          host = io.read(io.read.unpack('C').first).unpack('C*').join('.')
          port = Int.read(io)
          [host, port]
        end

      end

      class Consistency

        ANY = "\x00\x00"
        ONE = "\x00\x01"
        TWO = "\x00\x02"
        THREE = "\x00\x03"
        QUORUM = "\x00\x04"
        ALL = "\x00\x05"
        LOCAL_QUORUM = "\x00\x06"
        EACH_QUORUM = "\x00\x07"

      end

      class StringMap

        def self.encode(map)
          map_bytes = map.each_pair.
            map { |k, v| "#{String.encode(k)}#{String.encode(v)}" }.join
          "#{Short.encode(map.length)}#{map_bytes}"
        end

        def self.read(io)
          {}.tap do |map|
            Short.read(io).times do
              key, value = String.read(io), String.read(io)
              map[key] = value
            end
          end
        end

      end

      class StringMultimap

        def self.encode(map)
          map_bytes = map.each_pair.
            map { |k, v| "#{String.encode(k)}#{StringList.encode(v)}" }.join
          "#{Short.encode(map.length)}#{map_bytes}"
        end

        def self.read(io)
          {}.tap do |map|
            Short.read(io).times do
              key, values = String.read(io), StringList.read(io)
              map[key] = values
            end
          end
        end

      end

    end

  end

end
