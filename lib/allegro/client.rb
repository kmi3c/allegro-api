module Allegro

  AUTH_URI = 'https://allegro.pl/auth/oauth'
  API_URI = 'https://api.allegro.pl/'

  class Client

    attr_reader :http_agent

    def initialize(client_id, secret, _options = {})
      @http_agent = Http::Agent.new({client_id: client_id, secret: secret})
    end

    def authorize
      response = @http_agent.fetch(
        auth_url('token'),
        { grant_type: 'client_credentials', method: :post }
      )
      @access_token = response[:access_token]
      @authorized = true if response && @access_token
    end

    def authorized?
      @authorized
    end

    def api_url(url)
      [API_URI, url.to_s].join('/')
    end

    def auth_url(url)
      [AUTH_URI, url.to_s].join('/')
    end

  end
end
