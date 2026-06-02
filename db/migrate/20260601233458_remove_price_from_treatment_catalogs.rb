class RemovePriceFromTreatmentCatalogs < ActiveRecord::Migration[8.1]
  def change
    remove_column :treatment_catalogs, :price, :decimal
  end
end
