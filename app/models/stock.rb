class Stock < ApplicationRecord
  require 'rss'

  validates :name, presence: true
  validate :check_name

  belongs_to :user

  def check_name
    errors.add(:base, 'I cannot find that stock') unless StockQuote::Stock.chart(name)
  end

  def get_rss_feed
    return nil unless rss_url


    uri = URI(rss_url)
    rss = Net::HTTP.get(uri)
    feed = RSS::Parser.parse(rss)

    rss_array = feed.items.map do |item|
      { title: item.title, link: item.link }
    end

  end


end
