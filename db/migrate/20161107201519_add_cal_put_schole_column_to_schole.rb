class AddCalPutScholeColumnToSchole < ActiveRecord::Migration
  def change
    add_column :scholes, :cal_option_val, :boolean
    add_column :scholes, :put_option_val, :boolean
  end
end
