class GoogleTrends
  require 'net/http' 


  def self.test
    stocks = StockQuote::Stock.quote("aapl,tsla")
  end

  def self.get_trend(name:)

    uri = URI("https://trends.google.com/trends/explore?q=#{name}&geo=US")

    cookie = get_cookie

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|

      request = Net::HTTP::Get.new(uri)
      request['Cookie'] = cookie
      request['content-type'] = 'application/json'
      request.initialize_http_header({"Accept" => "application/json"})

      response = http.request request # Net::HTTPResponse object

      puts response.body

    end


  end

  private

  def self.get_cookie

    uri = URI('https://trends.google.com/trends/?geo=US')

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|

      request = Net::HTTP::Get.new(uri)

      return http.request(request)['set-cookie']

    end

  end


end















