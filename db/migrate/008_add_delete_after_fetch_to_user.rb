class AddDeleteAfterFetchToUser < ActiveRecord::Migration
  
  def change
    add_column :users, :sipgate_delete_after_fetch, :boolean, :default => false
  end
  
end