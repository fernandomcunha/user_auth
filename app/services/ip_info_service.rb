# frozen_string_literal: true

require 'net/http'
require 'json'

class IpInfoService
  class IpInfoError < StandardError; end

  BASE_URL = 'https://ipinfo.io'

  def self.fetch_ip_info
    new.fetch_ip_info
  end

  def initialize
    @token = ENV.fetch('IP_INFO_TOKEN')
  end

  def fetch_ip_info
    uri = URI("#{BASE_URL}?token=#{@token}")
    response = Net::HTTP.get_response(uri)

    raise IpInfoError, "Failed to fetch IP info: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end
end
