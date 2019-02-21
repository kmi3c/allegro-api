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
      request_params = params.select{|k,v| ![:method, :headers].include?(k)}
      headers = params[:headers]
      request = if method == :get
        uri.query = URI.encode_www_form(params)
        Net::HTTP::Get.new(uri.request_uri)
      elsif method == :post
        request = Net::HTTP::Post.new(uri.path)
        request.set_form_data(request_params)
        request
      end
      headers.each{|k,v| request[k.to_s] = v }
      request.basic_auth(options[:client_id], options[:secret])
      request
    end

    def parse_body(body, content_type)
      case content_type
      when /application\/(vnd\.allegro\.public\.v\d+\+json|json)/
        JSON.parse(body)
      else
        body
      end
    end


    def default_params
      { method: :get, headers: { accept: 'application/vnd.allegro.public.v1+json'}}
    end
  end
end

