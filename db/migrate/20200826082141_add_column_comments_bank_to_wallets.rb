class AddColumnCommentsBankToWallets < ActiveRecord::Migration[6.0]
  def change
    add_column :wallets, :comments, :string
    add_column :wallets, :bank, :string
  end
end
