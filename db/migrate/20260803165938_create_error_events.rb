class CreateErrorEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :error_events do |t|
      t.references :application, null: false, foreign_key: true
      t.string :error_type
      t.text :error_message
      t.text :stack_trace
      t.datetime :occurred_at
      t.string :severity

      t.timestamps
    end
  end
end
