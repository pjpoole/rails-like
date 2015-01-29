require 'uri'

class Params
  def initialize(req, route_params = {})
    @params = req.query_string.nil? ? {} :
      parse_www_encoded_form(req.query_string)
    @params.merge!(parse_www_encoded_form(req.body)) unless req.body.nil?
  end

  def [](key)
    @params[key.to_s] || @params[key.to_sym]
  end

  def to_s
    @params.to_json.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  def parse_www_encoded_form(www_encoded_form)
    vars = URI::decode_www_form(www_encoded_form)
    params = {}
    vars.each do |var|
      # params[var[0].to_sym] = var[1]
      diver = params
      keys = parse_key(var[0])
      loop do
        key = keys.shift

        if keys.count == 0
          diver[key] = var[1]
          break
        end

        diver[key] ||= {}
        diver = diver[key]
      end
    end
    params
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    multikey = key.split(/\]\[|\[|\]/)
  end
end
