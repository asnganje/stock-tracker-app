require 'httparty'
class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks
  
    def self.company_lookup(ticker_symbol)
        response = HTTParty.get("https://www.alphavantage.co/query?function=OVERVIEW&symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.alpha_vantage_client[:alpha_vantage_key]}")
        if response.code == 200
          response.parsed_response['Name']
        else
          nil
        end
    end
  def self.new_lookup(ticker_symbol)
    response = HTTParty.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.alpha_vantage_client[:alpha_vantage_key]}")
    if response.code == 200 && response.parsed_response['Global Quote']
        last_price = response.parsed_response['Global Quote']['05. price']
        name = company_lookup(ticker_symbol)
        if name
          return new(ticker: ticker_symbol, name: name, last_price: last_price)
        end
    else
      nil
    end
end
end
