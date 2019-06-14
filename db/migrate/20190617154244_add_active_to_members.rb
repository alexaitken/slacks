class AddActiveToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :active, :boolean, default: true
  end
end
