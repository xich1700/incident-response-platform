# db/migrate/..._create_incident_analyses.rb
class CreateIncidentAnalyses < ActiveRecord::Migration[8.1]
  def change
    create_table :incident_analyses do |t|
      t.references :incident, foreign_key: true
      t.references :error_event, foreign_key: true
      t.string :status, null: false, default: "pending"
      t.text :root_causes
      t.text :affected_components
      t.text :investigation_steps
      t.jsonb :raw_response, default: {}
      t.text :error_message
      t.timestamps
    end
    add_index :incident_analyses, :status
  end
end
