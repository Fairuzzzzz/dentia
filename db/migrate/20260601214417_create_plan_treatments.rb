class CreatePlanTreatments < ActiveRecord::Migration[8.1]
  def change
    create_table :plan_treatments, id: :uuid do |t|
      t.references :plan,               null: false, foreign_key: true, type: :uuid
      t.references :treatment_catalog,  foreign_key: true, type: :uuid
      t.string  :tooth_number
      t.text    :notes
      t.integer :quantity, default: 1
      t.decimal :price, precision: 12, scale: 2
      t.timestamps
    end
  end
end
