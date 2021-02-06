class CreateAccountRequest < ActiveRecord::Migration[4.2]
  def change
    create_table :account_requests do |t|
      t.string :token
      t.string :email
      t.timestamps
    end
    add_index :account_requests, :token, unique: true
  end
end
