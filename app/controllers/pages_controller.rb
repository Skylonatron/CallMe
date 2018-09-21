class PagesController < ApplicationController

  def main
    @user = User.new
    if user_signed_in?
      redirect_to leads_path
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

    unless stock = StockQuote::Stock.chart(@symbol, '1m')
      redirect_to test_path and return
    end

    @chart = stock.chart

    @max = @chart.max_by do |s|
      s["open"]
    end['open']

    @min = @chart.min_by do |s|
      s["open"]
    end['open']

    @graph = @chart.map do |s|
      [s["date"], normalize(@max, @min, s["open"])]
    end
  end

  def search
    redirect_to test_path
  end

  private 

  def normalize(high, low, value)
    num = value - low
    dem = high - low

    return num / dem
  end
end









