class BillingItem < ApplicationRecord
  belongs_to :plan_treatment
  belongs_to :billing
end
