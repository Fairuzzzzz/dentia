class CreatePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :plans, id: :uuid do |t|
      t.references :medical_record, null: false, foreign_key: true, type: :uuid
      t.text :follow_up_plan
      t.date :next_visit_date
      t.timestamps
    end
  end
end
