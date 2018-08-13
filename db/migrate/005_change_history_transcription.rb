class ChangeHistoryTranscription < ActiveRecord::Migration
  
  def change
    change_column :sipgate_call_histories, :transcription, :text
  end
  
end