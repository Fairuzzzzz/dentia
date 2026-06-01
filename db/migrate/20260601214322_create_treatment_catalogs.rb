class CreateTreatmentCatalogs < ActiveRecord::Migration[8.1]
  def change
    create_table :treatment_catalogs, id: :uuid do |t|
      t.string :code, index: { unique: true }
      t.string :name, null: false
      t.decimal :price, precision: 12, scale: 2, default: 0
      t.string :category
      t.boolean :is_active, default: true
      t.timestamps
    end
  end
end
