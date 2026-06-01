class CreateAppointments < ActiveRecord::Migration[8.1]
  def change
    create_table :appointments, id: :uuid do |t|
      t.references :patient, null: false, foreign_key: true, type: :uuid
      t.datetime :appointment_date, null: false                
      t.string   :status, default: "scheduled"
      t.text     :purpose
      t.text     :notes
      t.timestamps
    end
    add_index :appointments, :appointment_date
  end
end
