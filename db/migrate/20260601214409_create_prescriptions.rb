class CreatePrescriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :prescriptions, id: :uuid do |t|
      t.references :plan, null: false, foreign_key: true, type: :uuid
      t.string :drug_name, null: false
      t.string :dosage
      t.string :frequency
      t.string :duration
      t.string :notes
      t.timestamps
    end
  end
end
