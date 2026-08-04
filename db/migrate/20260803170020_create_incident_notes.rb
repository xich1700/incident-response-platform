class CreateIncidentNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :incident_notes do |t|
      t.references :incident, null: false, foreign_key: true
      t.string :author
      t.text :body

      t.timestamps
    end
  end
end
