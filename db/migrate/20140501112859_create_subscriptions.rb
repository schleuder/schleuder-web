class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :subscriber_id
      t.integer :list_id
      t.boolean :admin, default: false
      t.boolean :delivery_disabled, default: false
      t.timestamps
    end

    add_index :subscriptions, :subscriber_id
    add_index :subscriptions, :list_id
    add_index :subscriptions, [:subscriber_id, :list_id], unique: true
  end
end
