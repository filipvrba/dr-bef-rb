module Bef
  class Database
    def initialize
      env = DotEnv.get

      # @query = query
      @bef_url_api = env[:URL_API]
      @name = env[:DATABASE]
      @client_token = env[:BEF_CLIENT]
      @server_token = env[:BEF_SERVER]
      @results = {}
    end

    def get(query, &callback)
      query_escape = Bef::Net.escape(query)
      uri = "#{@bef_url_api}?token=#{@client_token}" +
        "&database=#{@name}&query=#{query_escape}"
      @results[query_escape] ||= $gtk.http_get(uri)

      if @results[query_escape] and @results[query_escape][:complete] &&
          @results[query_escape][:http_response_code] > -1
        callback.call(@results[query_escape][:response_data])
      end
    end
  end
end