class AddColumnTradingFee < ActiveRecord::Migration[6.0]
  def change
    add_column :wallets, :trading_fee, :decimal
  end
end
