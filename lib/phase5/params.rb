require 'uri'
require 'byebug'

class HashWithIndifferentAccess
end

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
        @params = {}

        @params.merge!(parse_www_encoded_form(req.query_string)) unless req.query_string.nil? 
        @params.merge!(parse_www_encoded_form(req.body)) unless req.body.nil?  
        @params.merge!(route_params) 
    end

    def [](key)
        @params[key.to_s] || @params[key.to_sym]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
        nest_hashes(www_encoded_form)

        # url_params = URI::decode_www_form(www_encoded_form)
        # parsed = Hash[url_params]
        # parsed.keys.map! {|key| key.to_sym}
        # parsed
    end


    def nest_hashes(str) 
        str = str.split(/\?|\&|\=/)
        hash = {} 
        str.map! do |ary|
            parse_key(ary) 
        end
        str.each_with_index do |ary,idx|
            current = hash
            ary[0..-2].each do |el|
               current[el] ||= {}
                current = current[el]
            end
            if (idx%2 == 0)
                current[ary[-1]] = str[idx+1].first
            end
        end
        hash
    end









#     def parse_to_hash_improved(hash) 
#         h = Hash.new
#         hash.keys.each do |keys|
#             current = h 
#             keys[0..-2].each do |key|
#                 current[key] ||= {}
#                 current = current[key]
#             end
#             current[keys.last] = hash[keys].first
#         end
#         h
#     end



# "user[address][street]=main&user[address][zip]=89436"
          


#     def shitty_hashes(arr) 
#     h = Hash.new 
#     current = h
#     arr.each do |el| 
#         current[el] ||= {} 
#         current = current[el] 
#     end
#     h
# end





    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
        key.split(/\]\[|\[|\]/)
    end
  end
end
