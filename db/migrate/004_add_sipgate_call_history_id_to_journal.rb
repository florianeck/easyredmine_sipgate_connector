class AddSipgateCallHistoryIdToJournal < ActiveRecord::Migration
  
  def change
    add_column :journals, :sipgate_call_history_id, :integer
  end
  
end