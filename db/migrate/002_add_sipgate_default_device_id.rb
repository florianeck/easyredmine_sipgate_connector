class AddSipgateDefaultDeviceId < ActiveRecord::Migration
  
  def change
    add_column :users, :sipgate_default_device_id, :string
  end
  
end