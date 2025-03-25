require 'httparty'
class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true 
    def self.company_lookup(ticker_symbol)
        response = HTTParty.get("https://api.twelvedata.com/symbol_search?symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.dig(:twelve_data, :api_key)}")
        # response = HTTParty.get("https://www.alphavantage.co/query?function=OVERVIEW&symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.alpha_vantage_client[:alpha_vantage_key]}")
        # if response.code == 200
        #   response.parsed_response['Name']
        if response.code == 200 && response.parsed_response['data']
          company_info = response.parsed_response['data'].first
          company_info['instrument_name'] # This returns the company name
        else
        #   OR
        # if response.code == 200 && response.parsed_response['name']
        #   response.parsed_response['name']
        # else
          nil
        end
    end
  def self.new_lookup(ticker_symbol)
    # response = HTTParty.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.alpha_vantage_client[:alpha_vantage_key]}")
    response = HTTParty.get("https://api.twelvedata.com/quote?symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.dig(:twelve_data, :api_key)}")
    # if response.code == 200 && response.parsed_response['Global Quote']
    #     last_price = response.parsed_response['Global Quote']['05. price']
    #     name = company_lookup(ticker_symbol)
    if response.code == 200 && response.parsed_response['close']
      last_price = response.parsed_response['close']
      name = company_lookup(ticker_symbol)
        if name
          return new(ticker: ticker_symbol, name: name, last_price: last_price)
        end
    else
      nil
    end
  end
  def self.check_db(ticker_symbol)
    where(ticker:ticker_symbol).first
  end
end
