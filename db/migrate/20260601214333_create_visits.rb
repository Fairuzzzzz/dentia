class CreateVisits < ActiveRecord::Migration[8.1]
  def change
    create_table :visits, id: :uuid do |t|
      t.references :patient, null: false, foreign_key: true, type: :uuid
      t.string :visit_number, index: { unique: true }
      t.datetime :visit_date, null: false
      t.text :chief_complaint
      t.string :status, default: "registered"
      t.timestamps
    end
  end
end
