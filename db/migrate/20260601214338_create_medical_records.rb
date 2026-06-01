class CreateMedicalRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :medical_records, id: :uuid do |t|
      t.references :visit, null: false, foreign_key: true, type: :uuid, index: { unique:true }
      t.timestamps
    end
  end
end
