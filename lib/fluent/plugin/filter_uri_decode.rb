require 'fluent/filter'
require 'fluent/plugin'

require "cgi"

module Fluent
  class URIDecoderFilter < Filter
    Plugin.register_filter("uri_decode", self)

    config_param :key_name, :string, :default => nil
    config_param :key_names, :string, :default => ''

    def configure(conf)
      super
      @_key_names ||= @key_names.split(/,\s*/)
      @_key_names << @key_name if @key_name
      @_key_names.uniq!
    end

    def filter(tag, time, record)
      @_key_names.each do |key_name|
        next unless record.key?(key_name)
        record[key_name] = CGI.unescape(record[key_name])
      end
      record
    end

  end
end
