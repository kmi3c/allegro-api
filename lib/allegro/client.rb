module Allegro

  AUTH_URI = 'https://allegro.pl/auth/oauth'
  API_URI = 'https://api.allegro.pl'

  class Client

    attr_reader :http_agent

    def initialize(client_id, secret, _options = {})
      @http_agent = Http::Agent.new(_options)
      @authorized = false
      authorize(client_id, secret)
    end

    def authorized?
      @authorized
    end

    def authorize(client_id, secret)
      auth_token = Base64.strict_encode64("#{client_id}:#{secret}")
      response = @http_agent.fetch(
        auth_url('token'),
        {
          method: :post,
          grant_type: 'client_credentials',
          headers: default_headers.merge({
            authorization: "Basic #{auth_token}"
          })
        }
      )
      @access_token = response['access_token']
      @token_type = response['token_type']
      @authorized = true if response && @access_token
    end

    def get(resource, params)
      @http_agent.fetch(
        api_url(resource), default_params.merge(params)
      )
    end

    def search(params)
      @http_agent.fetch(
        api_url('offers/listing'), default_params.merge(params)
      )
    end

    def api_url(url)
      [API_URI, url.to_s].join('/')
    end

    def auth_url(url)
      [AUTH_URI, url.to_s].join('/')
    end

    def default_params
      {
        method: :get, headers: default_headers
      }
    end

    def default_headers
      {
        accept: 'application/vnd.allegro.public.v1+json',
        authorization: "#{@token_type} #{@access_token}"
      }
    end

  end
end
