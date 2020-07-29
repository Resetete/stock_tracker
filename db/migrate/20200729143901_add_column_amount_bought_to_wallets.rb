class AddColumnAmountBoughtToWallets < ActiveRecord::Migration[6.0]
  def change
    add_column :wallets, :amount_bought, :decimal
  end
end
