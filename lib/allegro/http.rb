require 'logger'

module Http
  class Agent
    attr_accessor :options, :logger
    attr_reader :authorized

    def initialize(_options = {})
      @logger = Logger.new(STDOUT)
      @options = _options
    end

    # TODO: split to more atomic methods fe: handle_error, prepare request, etc.
    def fetch(uri, params = {})
      uri = URI(uri)
      body = []
      begin
        session = Net::HTTP.new(uri.host, uri.port)
        session.use_ssl = uri.scheme == 'https'
        response = session.start do |http|
          request = build_request(uri, params)
          begin
            http.request(request) do |resp|
              resp.read_body do |segment|
                body << segment
              end
            end
          rescue StandardError => e
            logger.error e.message
          ensure
            body = body.join('')
          end
        end
        case response
        when Net::HTTPSuccess
          body = parse_body(body, response.content_type)
        when Net::HTTPRedirection
          raise StandardError, response.message
        else
          body = parse_body(body, response.content_type)
          return body if body.is_a?(Hash)

          raise StandardError, response.message
        end
      rescue StandardError => e
        logger.error e.message
        body = []
        raise e
      end
      body
    end

    protected

    def build_request(uri, params)
      method = params[:method]
      request_params = params.reject { |k, _v| %i[method headers].include?(k) }
      headers = params[:headers]
      request = if method == :get
                  uri.query = URI.encode_www_form(params)
                  Net::HTTP::Get.new(uri.request_uri)
                elsif method == :post
                  request = Net::HTTP::Post.new(uri.path)
                  request.set_form_data(request_params)
                  request
      end
      headers.each { |k, v| request[k.to_s] = v }
      request
    end

    def parse_body(body, content_type)
      json?(content_type) ? JSON.parse(body) : body
    end

    def json?(content_type)
      !!content_type.match(%r{application/(vnd\.allegro\.public\.v\d+\+json|json)})
    end
  end
end
