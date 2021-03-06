=begin
Copyright 2011 Inside Systems, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=end

require 'zlib'

module CassandraCQL
  class Utility
    def self.compress(source, level=2)
      Zlib::Deflate.deflate(source, level)
    end
    
    def self.decompress(source)
      Zlib::Inflate.inflate(source)
    end

    def self.binary_data?(string)
      if RUBY_VERSION >= "1.9"
        string.encoding.name == "ASCII-8BIT"
      else
        string.count("\x00-\x7F", "^ -~\t\r\n").fdiv(string.size) > 0.3 || string.index("\x00") unless string.empty?
      end
    end
  end
end