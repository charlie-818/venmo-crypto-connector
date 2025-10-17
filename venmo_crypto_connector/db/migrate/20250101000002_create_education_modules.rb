class CreateEducationModules < ActiveRecord::Migration[7.0]
  def change
    create_table :venmo_crypto_connector_education_modules do |t|
      t.string :title, null: false
      t.text :description
      t.integer :sequence_number, null: false
      t.integer :estimated_duration_minutes
      t.string :module_type # video, interactive, quiz, reading
      t.jsonb :content_data
      t.jsonb :quiz_questions
      t.integer :unlock_xp_requirement, default: 0
      t.string :icon_class
      t.string :color_theme
      
      t.timestamps
    end

    create_table :venmo_crypto_connector_module_completions do |t|
      t.references :user, foreign_key: { to_table: :venmo_crypto_connector_users }
      t.references :education_module, foreign_key: { to_table: :venmo_crypto_connector_education_modules }
      t.integer :time_spent_seconds
      t.integer :quiz_score
      t.datetime :completed_at
      
      t.timestamps
    end

    add_index :venmo_crypto_connector_education_modules, :sequence_number, unique: true
    add_index :venmo_crypto_connector_module_completions, [:user_id, :education_module_id], 
              unique: true, name: 'index_module_completions_user_module'
  end
end
