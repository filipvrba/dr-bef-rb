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

    def send(method, query, &callback)
      method = method.upcase
      query_escape = Bef::Net.escape(query)
      header = [
        "Token: #{@server_token}",
        "Database: #{@name}",
        "Query: #{query}",
      ]
      @results[query_escape] ||= $gtk.http_post(@bef_url_api, nil, header)
      
      if @results[query_escape] and @results[query_escape][:complete] &&
          @results[query_escape][:http_response_code] > -1
        callback.call(@results[query_escape][:response_data]) if callback
      end
    end

    def get(query, &callback)
      query_escape = Bef::Net.escape(query)
      uri = "#{@bef_url_api}?token=#{@client_token}" +
        "&database=#{@name}&query=#{query_escape}"
      @results[query_escape] ||= $gtk.http_get(uri)

      if @results[query_escape] and @results[query_escape][:complete] &&
          @results[query_escape][:http_response_code] > -1
        callback.call(@results[query_escape][:response_data]) if callback
      end
    end

    def set(query, &callback)
      is_active = false
      low_query = query.downcase

      if low_query.index('insert into') ||
         low_query.index('create table')
        is_active = true
        send('post', query) do |data|
          callback.call(data) if callback
        end
      elsif low_query.index('delete')
        is_active = true
        send('delete', query) do |data|
          callback.call(data) if callback
        end
      elsif low_query.index('update')
        is_active = true
        send('patch', query) do |data|
          callback.call(data) if callback
        end
      end

      return is_active
    end # set
  end
end