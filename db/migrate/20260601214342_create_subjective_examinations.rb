class CreateSubjectiveExaminations < ActiveRecord::Migration[8.1]
  def change
    create_table :subjective_examinations, id: :uuid do |t|
      t.references :medical_record, null: false, foreign_key: true, type: :uuid
      t.text :chief_complaint
      t.text :present_illness_history
      t.timestamps
    end
  end
end
