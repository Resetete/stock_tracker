class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :ticker, presence: true

  def self.new_lookup(ticker_symbol)
    client = create_client
    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))
    rescue => exception
      puts "Exception when retrieving stock course: #{exception}"
      return nil
    end
  end

  def self.new_crypto_lookup(ticker_symbol, currency = 'EUR')
    begin
      new(ticker: ticker_symbol, last_price: call_crypto_api(ticker_symbol, currency = 'EUR'))
    rescue => exception
      puts "Exception when retrieving stock course: #{exception}"
      return nil
    end
  end

  def self.logo_look_up(ticker_symbol)
    create_client.logo(ticker_symbol).url
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  private

  def self.create_client
    IEX::Api::Client.new(publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
                                  endpoint: 'https://sandbox.iexapis.com/v1')
  end

  def self.call_crypto_api(ticker_symbol, currency = 'EUR')
    # https://min-api.cryptocompare.com/documentation
    api_url = URI.parse("https://min-api.cryptocompare.com/data/price?fsym=#{ticker_symbol}&tsyms=#{currency}")
    response = Net::HTTP.get_response(api_url)
    json_response = JSON.parse(response.body)[currency]
  end
end
