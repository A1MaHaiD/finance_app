class ChangeAmountScaleInOperations < ActiveRecord::Migration[8.0]
  def up
    change_column :operations, :amount, :decimal, precision: 10, scale: 2
  end

  def down
    change_column :operations, :amount, :decimal, precision: 10, scale: 0
  end
end
