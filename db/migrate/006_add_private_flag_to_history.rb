class AddPrivateFlagToHistory < ActiveRecord::Migration
  
  def change
    add_column :sipgate_call_histories, :private_call, :boolean, default: false
  end
  
end