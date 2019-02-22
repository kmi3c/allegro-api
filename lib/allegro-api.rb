require 'net/http'
require 'json'
require 'base64'
require 'allegro/version'
require 'allegro/client'
require 'allegro/http'

module Allegro

  attr_reader :client

  def initialize(client_id, secret)
    @client = Allegro::Client.new(client_id, secret)
  end

end
