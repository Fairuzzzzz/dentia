class CreateOdontograms < ActiveRecord::Migration[8.1]
  def change
    create_table :odontograms, id: :uuid do |t|
      t.references :objective_examination, null: false, foreign_key: true, type: :uuid
      t.jsonb :teeth_data, default: {}
      t.text  :notes
      t.timestamps
    end
  end
end
