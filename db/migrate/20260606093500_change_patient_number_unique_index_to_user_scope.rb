class ChangePatientNumberUniqueIndexToUserScope < ActiveRecord::Migration[8.1]
  def change
    remove_index :patients, :patient_number
    add_index :patients, [:user_id, :patient_number], unique: true
  end
end
