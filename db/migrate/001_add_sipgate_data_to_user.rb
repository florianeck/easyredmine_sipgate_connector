class AddSipgateDataToUser < ActiveRecord::Migration
  
  def change
    add_column :users, :sipgate_user_id, :string
    add_column :users, :sipgate_devices, :text
    add_column :users, :sipgate_token, :string
  end
  
end