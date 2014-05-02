class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :email
      t.string :password_digest
    end

    add_index :accounts, :email, unique: true
  end
end
