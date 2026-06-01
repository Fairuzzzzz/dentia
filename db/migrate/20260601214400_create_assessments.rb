class CreateAssessments < ActiveRecord::Migration[8.1]
  def change
    create_table :assessments, id: :uuid do |t|
      t.references :medical_record, null: false, foreign_key: true, type: :uuid
      t.string :icd_code
      t.text   :diagnosis
      t.text   :diagnosis_notes
      t.timestamps
    end
  end
end
