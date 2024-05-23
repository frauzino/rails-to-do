class ChangeTodosStringToText < ActiveRecord::Migration[7.0]
  def change
    change_column :todos, :content, :text
  end
end
