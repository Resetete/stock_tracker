FactoryBot.define do
  factory :profit do
    ticker { 'BTC' }
    profit { 10 }
    date { DateTime.new(2020, 9, 1) }
    user_id { 1 }
  end
end
