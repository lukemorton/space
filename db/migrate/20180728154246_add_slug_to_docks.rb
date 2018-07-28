class AddSlugToDocks < ActiveRecord::Migration[5.2]
  def change
    add_column :docks, :slug, :string
    add_index :docks, :slug, unique: true
  end
end
