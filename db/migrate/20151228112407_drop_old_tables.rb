class DropOldTables < ActiveRecord::Migration
  def up
    drop_table :lists
    drop_table :subscriptions
  end
  
  def down
    raise StandardError 'not implemented'
  end
end
