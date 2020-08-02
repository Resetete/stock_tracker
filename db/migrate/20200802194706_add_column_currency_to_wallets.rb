class AddColumnCurrencyToWallets < ActiveRecord::Migration[6.0]
  def change
    add_column :wallets, :currency, :string
  end
end
