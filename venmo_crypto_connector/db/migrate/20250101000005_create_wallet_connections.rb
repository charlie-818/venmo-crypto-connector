class CreateWalletConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :venmo_crypto_connector_wallet_connections do |t|
      t.references :user, foreign_key: { to_table: :venmo_crypto_connector_users }
      t.string :address, null: false
      t.datetime :verified_at
      t.boolean :primary, default: false
      t.jsonb :metadata
      
      t.timestamps
    end

    add_index :venmo_crypto_connector_wallet_connections, [:user_id, :address], 
              unique: true, name: 'index_wallet_connections_user_address'
    add_index :venmo_crypto_connector_wallet_connections, :address
  end
end
