FactoryBot.define do
  factory :wallet do
    ticker { 'BTC' }
    buy_price { 8000 }
    buy_date { DateTime.new(2020, 8, 1) }
    user_id { 1 }
    trading_fee { 5 }
    last_price { 9000 }
  end
end
