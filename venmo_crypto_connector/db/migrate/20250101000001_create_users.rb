class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :venmo_crypto_connector_users do |t|
      t.string :email, null: false
      t.string :username
      t.string :eth_address
      t.string :eth_nonce
      t.string :venmo_username
      t.integer :onboarding_step, default: 0
      t.boolean :identity_verified, default: false
      t.boolean :wallet_connected, default: false
      t.boolean :can_transfer_external, default: false
      t.datetime :onboarded_at
      t.jsonb :completed_modules, default: []
      t.integer :experience_points, default: 0
      t.string :session_token
      t.datetime :session_expires_at
      
      t.timestamps
    end
    
    add_index :venmo_crypto_connector_users, :email, unique: true
    add_index :venmo_crypto_connector_users, :eth_address, unique: true
    add_index :venmo_crypto_connector_users, :venmo_username
    add_index :venmo_crypto_connector_users, :session_token
  end
end
