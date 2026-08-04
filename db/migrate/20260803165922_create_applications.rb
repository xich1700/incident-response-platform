class CreateApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :environment
      t.string :team_owner

      t.timestamps
    end
  end
end
