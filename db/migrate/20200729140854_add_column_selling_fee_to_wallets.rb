class AddColumnSellingFeeToWallets < ActiveRecord::Migration[6.0]
  def change
    add_column :wallets, :selling_fee, :decimal
  end
end
