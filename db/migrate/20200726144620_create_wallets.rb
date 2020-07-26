class CreateWallets < ActiveRecord::Migration[6.0]
  def change
    create_table :wallets do |t|
      t.string :name
      t.decimal :buy_price
      t.decimal :sell_price
      t.timestamp :buy_date
      t.timestamp :sell_date
      t.decimal :current_profit

      t.timestamps
    end
  end
end
