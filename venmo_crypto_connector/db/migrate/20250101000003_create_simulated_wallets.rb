class CreateSimulatedWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :venmo_crypto_connector_simulated_wallets do |t|
      t.references :user, foreign_key: { to_table: :venmo_crypto_connector_users }
      t.decimal :usdc_balance, precision: 10, scale: 6, default: 100.0
      t.decimal :ethereum_balance, precision: 18, scale: 8, default: 0.05
      t.decimal :bitcoin_balance, precision: 8, scale: 8, default: 0.001
      t.decimal :pyusd_balance, precision: 10, scale: 6, default: 50.0
      
      t.timestamps
    end

    create_table :venmo_crypto_connector_simulated_transactions do |t|
      t.references :user, foreign_key: { to_table: :venmo_crypto_connector_users }
      t.references :simulated_wallet, foreign_key: { to_table: :venmo_crypto_connector_simulated_wallets }
      t.string :transaction_type # purchase, send_internal, send_external, receive
      t.string :cryptocurrency
      t.decimal :amount, precision: 18, scale: 8
      t.string :destination_address
      t.string :transaction_hash
      t.string :status # pending, confirmed, failed
      t.text :error_message
      t.datetime :confirmed_at
      t.jsonb :metadata
      
      t.timestamps
    end

    add_index :venmo_crypto_connector_simulated_transactions, :transaction_hash
    add_index :venmo_crypto_connector_simulated_transactions, :status
  end
end
