class AddNameToDocks < ActiveRecord::Migration[5.2]
  def change
    add_column :docks, :name, :string
  end
end
