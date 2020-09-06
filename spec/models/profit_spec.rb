require 'rails_helper'

RSpec.describe Profit, type: :model do

  before(:all) do
    @current_user = FactoryBot.create(:user)
    FactoryBot.create(:profit)
    FactoryBot.build(:wallet, ticker: 'BTC')
    FactoryBot.build(:wallet, ticker: 'ETH')
  end

  describe "Associations" do
    it { should belong_to(:user) }
  end

  describe '#already_fetched?' do
    it 'returns false if profit for that date is NOT already in profit table' do
      date1 = DateTime.new(2020, 8, 2)
      ticker1 = 'ETH'
      ticker2 = 'BTC'
      expect(described_class.already_fetched?(date1, ticker1, @current_user)).to eql(false)
      expect(described_class.already_fetched?(date1, ticker2, @current_user)).to eql(false)
    end

    it 'returns true if profit for that date is already in profit table' do
      date2 = DateTime.new(2020, 9, 1)
      ticker2 = 'BTC'
      expect(described_class.already_fetched?(date2, ticker2, @current_user)).to eql(true)
    end
  end

  describe '#daily_profit' do
    p described_class.daily_profit(@current_user)
  end
end
