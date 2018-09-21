class Stock < ApplicationRecord
  validates :name, presence: true
  validate :check_name

  belongs_to :user

  def check_name
    errors.add(:base, 'I cannot find that stock') unless StockQuote::Stock.chart(name)
  end


end
