class AddColumnsToLogin < ActiveRecord::Migration
  def change
    add_column :logins, :aggregate_id, :uuid
    add_column :logins, :email_address, :string
    add_column :logins, :sign_ins, :integer
  end
end
