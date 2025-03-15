class ChangeCategoryIdToBigintInOperationsToBigint < ActiveRecord::Migration[6.0]
def up
    # 1. Видалити зовнішній ключ
    remove_foreign_key :operations, :categories if foreign_key_exists?(:operations, :categories)

    # 2. Видалити індекс
    remove_index :operations, :category_id if index_exists?(:operations, :category_id)

    # 3. Змінити тип category_id на bigint
    change_column :operations, :category_id, :bigint

    # 4. Додати індекс назад
    add_index :operations, :category_id

    # 5. Відновити зовнішній ключ
    add_foreign_key :operations, :categories
  end

  def down
    # Відновлення для rollback
    remove_foreign_key :operations, :categories if foreign_key_exists?(:operations, :categories)
    remove_index :operations, :category_id if index_exists?(:operations, :category_id)
    change_column :operations, :category_id, :integer
    add_index :operations, :category_id
    add_foreign_key :operations, :categories
  end
end
