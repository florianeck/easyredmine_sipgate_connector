class CreateSipgateCallHistory < ActiveRecord::Migration
  
  def change
    create_table :sipgate_call_histories, :force => true do |t|
      t.integer   :user_id
      t.integer   :easy_contact_id
      t.string    :call_id
      t.string    :source
      t.string    :target
      t.string    :source_alias
      t.string    :target_alias
      t.string    :call_type
      t.datetime  :call_created_at
      t.string    :direction
      t.string    :transcription
      t.string    :recording_url
      t.integer   :duration
      t.timestamps
    end
    
    add_column :easy_contacts, :telephone_cached, :string
  end
  
end