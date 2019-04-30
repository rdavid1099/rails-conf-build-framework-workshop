require 'uri'
require "r00lz/version"

module R00lz
  class App
    def call(env)
      query = get_query(env['QUERY_STRING'])
      output = query['output'] == 'true' ? env.keys.map { |key| "#{key} => #{env[key]}"}.unshift('<p>').push('</p>').join("<br>") : ''
      [ 200, { 'Content-Type' => 'text/html' }, [query['body'].to_s, output] ]
    end

    def get_query(raw_string)
      raw_string.split('&').reduce({}) do |result, query|
        split_query = query.split('=')
        result[split_query.first] = URI.decode(split_query.last)
        result
      end
    end
  end
end
