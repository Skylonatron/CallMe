class PagesController < ApplicationController

  def main
    @user = User.new
    if user_signed_in?
      redirect_to stocks_path
    else
      redirect_to new_user_registration_path
    end
  end

  def test

    if params[:search]
      @symbol = params[:search][:search]
    else
      @symbol = "aapl"
    end

    get_chart_data

    @graph = @chart.map do |s|
      [s["date"], normalize(@max, @min, s["open"])]
    end
  end

  def test_trends
    @symbol = params[:symbol]

    get_chart_data

    dates = false
    dates_array = []
    CSV.foreach(params[:file].path, headers: false) do |row|

      if dates
        dates_array.append(row)
      elsif row[0]
        begin
           Date.parse(row[0])
           dates = true
           dates_array.append(row)
        rescue ArgumentError
           # handle invalid date
        end
      end

    end

    @graph = @chart.map do |s|
      [s["date"], normalize(@max, @min, s["open"])]
    end

    @graph = [ { name: "Stock", data: @graph }, { name: "Trends", data: dates_array }]

    render 'test'
  end

  private 

  def get_chart_data

    unless stock = StockQuote::Stock.chart(@symbol, '1m')
      redirect_to test_path and return
    end

    @chart = stock.chart

    @start = @chart.first['date']
    @end = @chart.last['date']

    @max = @chart.max_by do |s|
      s["open"]
    end['open']

    @min = @chart.min_by do |s|
      s["open"]
    end['open']

  end

  def normalize(high, low, value)
    num = value - low
    dem = high - low

    return (num / dem) * 100.0
  end
end









