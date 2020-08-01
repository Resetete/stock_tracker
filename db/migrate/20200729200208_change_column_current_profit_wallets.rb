class ChangeColumnCurrentProfitWallets < ActiveRecord::Migration[6.0]
  def change
    change_column :wallets, :current_profit, :decimal, precision: 10, scale: 2
  end
end
