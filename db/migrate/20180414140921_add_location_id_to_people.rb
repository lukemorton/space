class AddLocationIdToPeople < ActiveRecord::Migration[5.1]
  def change
    remove_column :people, :location
    add_reference :people, :location
  end
end
