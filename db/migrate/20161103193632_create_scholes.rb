class CreateScholes < ActiveRecord::Migration
  def change
    create_table :scholes do |t|
      t.float :stock_price
      t.float :strike_price
      t.float :years
      t.float :risk_free
      t.float :volatility
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
