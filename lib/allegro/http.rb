require 'logger'

module Http
  class Agent
    attr_accessor :options, :logger
    attr_reader :authorized

    def initialize(params = {})
      @logger = Logger.new(STDOUT)
      @options = params
      @authorized = false
    end

    # TODO: split to more atomic methods fe: handle_error, prepare request, etc.
    def fetch(uri, params = {})
      uri = URI(uri)
      params.merge!(default_params)
      method = params[:method]
      body = []
      begin
        session = Net::HTTP.new(uri.host, uri.port)
        session.use_ssl = uri.scheme == 'https'
        response = session.start do |http|
          request = Net::HTTP::Post.new(uri)
          request.basic_auth(options[:client_id], options[:secret])
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
          raise StandardError, response.message
        end
      rescue StandardError => e
        logger.error e.message
        body = []
        # raise e
      end
      body
    end

    def parse_body(body, content_type)
      case content_type
      when 'application/json'
        json = JSON.parse(body)
        json = json.is_a?(Array) ? json.each(&:deep_symbolize_keys!) : json.deep_symbolize_keys!
        json
      else
        body
      end
    end


    def default_params
      { method: :get, headers: [ accept: 'application/vnd.allegro.public.v1+json']}
    end
  end
end

