class AddColumnSoldToWallets < ActiveRecord::Migration[6.0]
  def change
    add_column :wallets, :sold, :boolean
  end
end
