class CreateIcdCodes < ActiveRecord::Migration[8.1]
  def change
    create_table :icd_codes do |t|
      t.string :code, null: false, index: { unique: true }
      t.text :description
      t.string :category

      t.timestamps
    end
  end
end
