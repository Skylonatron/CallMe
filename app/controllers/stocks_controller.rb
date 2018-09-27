class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update, :destroy]

  # GET /stocks
  # GET /stocks.json
  def index
    
    @stocks = current_user.stocks

    if @stocks.any?

      @graph_name = @stocks.find_by(id: params[:selected_stock])&.name || @stocks.first&.name
      stock = StockQuote::Stock.chart(@graph_name, '1d')
      chart = stock.chart

      @graph = chart.map do |s|
        ["#{s['date']} #{s['label']}", s["average"]] if s["average"] > 0
      end.compact
    end

    @buttons = [{ name: "New Stock", path: new_stock_path}]
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
    @buttons = [{ name: "Edit", path: edit_stock_path(@stock)}]

    @rss_feed = @stock.get_rss_feed
  end

  # GET /stocks/new
  def new
    @stock = current_user.stocks.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks
  # POST /stocks.json
  def create

    @stock = current_user.stocks.new(stock_params)

    respond_to do |format|
      if @stock.save
        format.html { redirect_to stocks_path, notice: 'Stock was successfully created.' }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to @stock, notice: 'Stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: 'Stock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params.require(:stock).permit(:name, :rss_url)
    end
end
