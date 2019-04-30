require 'uri'
require "r00lz/version"

module R00lz
  class App
    def call(env)
      query = get_query(env['QUERY_STRING'])
      output = query['output'] == 'true' ? env.keys.map { |key| "#{key} => #{env[key]}"}.unshift('<p>').push('</p>').join("<br>") : ''
      klass, act = cont_and_act(env)
      navbar = '<a href="/">HOME</a> | <a href="/q/a_quote">A Quote</a> | <a href="/q/another_quote">Another Quote</a>'
      text = klass ? klass.new(env).send(act) : ''
      [ 200, { 'Content-Type' => 'text/html' }, [navbar, text, query['body'].to_s, output] ]
    end

    def cont_and_act(env)
      _, con, act, after = env["PATH_INFO"].split('/')
      return [Object.const_get('RootController'), 'index'] if con.nil?

      con = con.capitalize + "Controller"
      [ Object.const_get(con), act ]
    end

    def get_query(raw_string)
      raw_string.split('&').reduce({}) do |result, query|
        split_query = query.split('=')
        result[split_query.first] = URI.decode(split_query.last)
        result
      end
    end
  end

  class Controller
    attr_reader :env

    def initialize(env)
      @env = env
    end
  end
end
