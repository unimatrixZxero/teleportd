require 'curb'
require 'hashie'
require 'json'

module Teleportd
  END_POINT = 'http://api.teleportd.com/'.freeze
  DEFAULT_FETCH_SIZE = 30.freeze
  class Config
    class << self
      attr_accessor :token
    end
  end

  def query(method, params)
    uri = api_path(method) + '&' + params
    puts uri
    results = JSON::parse Curl::Easy.perform(uri).body_str
    results = (results && results['ok'] ? results : {})
    Hashie::Mash.new(results)
  end

  def api_path(method)
     "#{END_POINT}#{method}?user_key=#{Teleportd::Config.token}"
  end

  def search_location(lat, long, vertical_span = 1, horizontal_span = 1, page = 0)
    query('search', "loc=[#{normalize_coords(lat)},#{normalize_coords(long)},#{vertical_span.to_f},#{horizontal_span.to_f}]&size=#{DEFAULT_FETCH_SIZE}&from=#{page * 100}").hits
  end

  def details(sha)
    query 'get', "sha=#{sha}"
  end

  def normalize_coords(coord)
    "%2.2f" % coord
  end
end