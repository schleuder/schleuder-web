class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :email
      t.string :fingerprint
      t.string :password_digest
    end
  end
end
