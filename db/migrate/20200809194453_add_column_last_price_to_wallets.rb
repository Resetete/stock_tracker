class AddColumnLastPriceToWallets < ActiveRecord::Migration[6.0]
  def change
    add_column :wallets, :last_price, :decimal, precision: 10, scale: 2
  end
end
