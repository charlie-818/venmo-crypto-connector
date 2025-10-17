class CreateVenmoGuides < ActiveRecord::Migration[7.0]
  def change
    create_table :venmo_crypto_connector_venmo_guides do |t|
      t.string :title, null: false
      t.text :description
      t.string :action, null: false # identity_verification, first_crypto_purchase, etc.
      t.integer :estimated_duration_minutes
      t.integer :xp_reward, default: 100
      t.string :icon_class
      t.string :color_theme
      t.jsonb :metadata
      
      t.timestamps
    end

    create_table :venmo_crypto_connector_venmo_guide_steps do |t|
      t.references :venmo_guide, foreign_key: { to_table: :venmo_crypto_connector_venmo_guides }
      t.string :title, null: false
      t.text :instructions
      t.integer :step_type # screenshot, video_clip, text_instruction, checklist, warning
      t.integer :sequence, null: false
      t.string :image_url
      t.string :video_url
      t.jsonb :annotations
      t.jsonb :checklist_items
      t.text :content
      
      t.timestamps
    end

    create_table :venmo_crypto_connector_venmo_guide_progresses do |t|
      t.references :user, foreign_key: { to_table: :venmo_crypto_connector_users }
      t.references :venmo_guide, foreign_key: { to_table: :venmo_crypto_connector_venmo_guides }
      t.integer :completed_steps, default: 0
      t.integer :completion_percentage, default: 0
      t.datetime :completed_at
      
      t.timestamps
    end

    add_index :venmo_crypto_connector_venmo_guides, :action, unique: true
    add_index :venmo_crypto_connector_venmo_guide_steps, [:venmo_guide_id, :sequence], 
              unique: true, name: 'index_guide_steps_guide_sequence'
    add_index :venmo_crypto_connector_venmo_guide_progresses, [:user_id, :venmo_guide_id], 
              unique: true, name: 'index_guide_progresses_user_guide'
  end
end
