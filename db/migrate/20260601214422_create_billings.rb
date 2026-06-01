class CreateBillings < ActiveRecord::Migration[8.1]
  def change
    create_table :billings, id: :uuid do |t|
      t.references :visit, null: false, foreign_key: true, type: :uuid
      t.decimal :total_amount,   precision: 12, scale: 2, default: 0
      t.string  :payment_method
      t.string  :payment_status, default: "unpaid"
      t.datetime :paid_at
      t.text     :notes
      t.timestamps
    end
  end
end
