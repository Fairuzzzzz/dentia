class TreatmentCatalogsController < ApplicationController
  before_action :set_treatment_catalog, only: [ :edit, :update, :destroy ]

  def index
    @treatment_catalogs = TreatmentCatalog.order(:code)
  end

  def new
    @treatment_catalog = TreatmentCatalog.new
  end

  def create
    @treatment_catalog = TreatmentCatalog.new(treatment_catalog_params)
    if @treatment_catalog.save
      redirect_to treatment_catalogs_path, notice: "Treatment berhasil ditambahkan"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @treatment_catalog.update(treatment_catalog_params)
      redirect_to treatment_catalogs_path, notice: "Treatment berhasil diperbarui"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @treatment_catalog.destroy!
    redirect_to treatment_catalogs_path, notice: "Treatment berhasil dihapus"
  end

  private

  def set_treatment_catalog
    @treatment_catalog = TreatmentCatalog.find(params[:id])
  end

  def treatment_catalog_params
    params.require(:treatment_catalog).permit(:code, :name, :category, :is_active)
  end
end
