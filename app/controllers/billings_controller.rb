class BillingsController < ApplicationController
  before_action :set_billing, only: [ :show, :mark_as_paid, :print_invoice ]

  def index
    @billings = Billing.includes(visit: :patient).order(created_at: :desc)

    if params[:status].present?
      @billings = @billings.where(payment_status: params[:status])
    end

    if params[:search].present?
      @billings = @billings.joins(visit: :patient).where("patients.name ILIKE :q OR patients.nik ILIKE :q", q: "%#{params[:search]}%")
    end
  end

  def show
  end

  def mark_as_paid
    if @billing.update(payment_status: "paid", paid_at: Time.current, payment_method: params[:payment_method])
      redirect_to @billing, notice: "Pembayaran berhasil dicatat"
    end
  end

  def print_invoice
  end

  private

  def set_billing
    @billing = Billing.includes(visit: { patient: nil }, billing_items: :plan_treatment).find(params[:id])
  end
end
