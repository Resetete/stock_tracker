class AddColumnTickerNameToWallets < ActiveRecord::Migration[6.0]
  def change
    add_column :wallets, :ticker, :string
  end
end
