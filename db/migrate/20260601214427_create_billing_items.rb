class CreateBillingItems < ActiveRecord::Migration[8.1]
  def change
    create_table :billing_items, id: :uuid do |t|
      t.references :billing,         null: false, foreign_key: true, type: :uuid
      t.references :plan_treatment,  foreign_key: true, type: :uuid
      t.string  :treatment_name
      t.integer :quantity, default: 1
      t.decimal :unit_price,  precision: 12, scale: 2
      t.decimal :total_price, precision: 12, scale: 2
      t.timestamps
    end
  end
end
