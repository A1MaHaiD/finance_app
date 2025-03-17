namespace :data do
  desc "Перенесення операцій з SQLite в MySQL"
  task transfer_operations: :environment do
    missing_ops = SqliteOperation.where("category_id NOT IN (SELECT id FROM categories)")

    missing_ops.each do |op|
      mysql_category = Category.find_by(id: op.category_id)
      unless mysql_category
        mysql_category = Category.create(
          id: op.category_id,
          name: "Placeholder Category",
          description: "Created for missing operations"
        )
      end
      Operation.create(
        amount:      op.amount,
        operation_type: op.operation_type,
        odate:       op.odate,
        description: op.description,
        category_id: mysql_category.id,
        created_at:  op.created_at,
        updated_at:  op.updated_at
      )
    end
    puts "Перенесено #{missing_ops.count} записів"
  end
end
