class AddNameToLogin < ActiveRecord::Migration
  def change
    add_column :logins, :name, :string
  end
end
