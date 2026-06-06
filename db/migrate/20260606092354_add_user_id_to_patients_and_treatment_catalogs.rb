class AddUserIdToPatientsAndTreatmentCatalogs < ActiveRecord::Migration[8.1]
  def change
    add_reference :patients, :user, type: :uuid, foreign_key: true
    add_reference :treatment_catalogs, :user, type: :uuid, foreign_key: true
  end
end
