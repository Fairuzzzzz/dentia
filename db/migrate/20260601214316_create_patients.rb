class CreatePatients < ActiveRecord::Migration[8.1]
  def change
    create_table :patients, id: :uuid do |t|
      t.string :nik, index: { unique: true }
      t.string :name, null: false
      t.date :birth_date
      t.string :gender
      t.text :address
      t.string :phone
      t.string :blood_type
      t.text :allergies
      t.string :patient_number, index: { unique: true }
      t.datetime :discarded_at, index: true
      t.timestamps
    end
  end
end
