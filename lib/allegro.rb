require 'allegro/version'
require 'allegro/client'
require 'allegro/http'
require 'net/http'
require 'json'

module Allegro

  attr_reader :client

  def initialize(client_id, secret)
    @client = Allegro::Client.new(client_id, secret)
  end

end
