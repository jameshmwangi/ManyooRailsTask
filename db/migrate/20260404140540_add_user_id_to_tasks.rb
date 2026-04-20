class AddUserIdToTasks < ActiveRecord::Migration[6.0]
  def up
    add_reference :tasks, :user, foreign_key: true

    execute <<-SQL.squish
      UPDATE tasks
      SET user_id = (SELECT id FROM users ORDER BY id LIMIT 1)
      WHERE user_id IS NULL
      AND EXISTS (SELECT 1 FROM users)
    SQL

    execute "DELETE FROM tasks WHERE user_id IS NULL"

    change_column_null :tasks, :user_id, false
  end

  def down
    remove_reference :tasks, :user, foreign_key: true
  end
end
