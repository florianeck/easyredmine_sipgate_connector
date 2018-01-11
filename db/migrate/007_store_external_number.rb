class StoreExternalNumber < ActiveRecord::Migration
  
  def change
    add_column :sipgate_call_histories, :external_number, :string
  end
  
end