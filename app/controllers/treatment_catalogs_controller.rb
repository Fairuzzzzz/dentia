class TreatmentCatalogsController < ApplicationController
  before_action :set_treatment_catalog, only: [ :edit, :update, :destroy ]

  def index
    @treatment_catalogs = current_user.treatment_catalogs.order(:code)
  end

  def new
    @treatment_catalog = current_user.treatment_catalogs.build
  end

  def create
    @treatment_catalog = current_user.treatment_catalogs.build(treatment_catalog_params)
    if @treatment_catalog.save
      redirect_to treatment_catalogs_path, notice: t("treatment.flash.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @treatment_catalog.update(treatment_catalog_params)
      redirect_to treatment_catalogs_path, notice: t("treatment.flash.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @treatment_catalog.destroy!
    redirect_to treatment_catalogs_path, notice: t("treatment.flash.deleted")
  end

  private

  def set_treatment_catalog
    @treatment_catalog = current_user.treatment_catalogs.find(params[:id])
  end

  def treatment_catalog_params
    params.require(:treatment_catalog).permit(:code, :name, :category, :is_active)
  end
end
