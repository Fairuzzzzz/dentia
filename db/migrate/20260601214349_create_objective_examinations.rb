class CreateObjectiveExaminations < ActiveRecord::Migration[8.1]
  def change
    create_table :objective_examinations, id: :uuid do |t|
      t.references :medical_record, null: false, foreign_key: true, type: :uuid
      t.integer :systole
      t.integer :diastole
      t.integer :heart_rate
      t.string  :consciousness
      t.integer :respiration_rate
      t.decimal :height,              precision: 5,  scale: 2
      t.decimal :weight,              precision: 5,  scale: 2
      t.decimal :body_temperature,    precision: 4,  scale: 1
      t.decimal :waist_circumference, precision: 5,  scale: 2
      t.decimal :bmi,                 precision: 5,  scale: 2
      t.text    :physical_examination
      t.string  :supporting_action
      t.text    :lab_result_notes
      t.timestamps
    end
  end
end
