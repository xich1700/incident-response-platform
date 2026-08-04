# db/migrate/..._create_incidents.rb
class CreateIncidents < ActiveRecord::Migration[8.1]
  def change
    create_table :incidents do |t|
      t.string :title, null: false
      t.string :status, null: false, default: "open"
      t.datetime :resolved_at
      t.references :error_event, foreign_key: true
      t.timestamps
    end
    add_index :incidents, :status
  end
end
