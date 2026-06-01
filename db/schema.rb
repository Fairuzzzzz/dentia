# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_01_221413) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "appointments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "appointment_date", null: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.uuid "patient_id", null: false
    t.text "purpose"
    t.string "status", default: "scheduled"
    t.datetime "updated_at", null: false
    t.index ["appointment_date"], name: "index_appointments_on_appointment_date"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
  end

  create_table "assessments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "diagnosis"
    t.text "diagnosis_notes"
    t.string "icd_code"
    t.uuid "medical_record_id", null: false
    t.datetime "updated_at", null: false
    t.index ["medical_record_id"], name: "index_assessments_on_medical_record_id"
  end

  create_table "billing_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "billing_id", null: false
    t.datetime "created_at", null: false
    t.uuid "plan_treatment_id"
    t.integer "quantity", default: 1
    t.decimal "total_price", precision: 12, scale: 2
    t.string "treatment_name"
    t.decimal "unit_price", precision: 12, scale: 2
    t.datetime "updated_at", null: false
    t.index ["billing_id"], name: "index_billing_items_on_billing_id"
    t.index ["plan_treatment_id"], name: "index_billing_items_on_plan_treatment_id"
  end

  create_table "billings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "notes"
    t.datetime "paid_at"
    t.string "payment_method"
    t.string "payment_status", default: "unpaid"
    t.decimal "total_amount", precision: 12, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.uuid "visit_id", null: false
    t.index ["visit_id"], name: "index_billings_on_visit_id"
  end

  create_table "medical_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "visit_id", null: false
    t.index ["visit_id"], name: "index_medical_records_on_visit_id", unique: true
  end

  create_table "objective_examinations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "bmi", precision: 5, scale: 2
    t.decimal "body_temperature", precision: 4, scale: 1
    t.string "consciousness"
    t.datetime "created_at", null: false
    t.integer "diastole"
    t.integer "heart_rate"
    t.decimal "height", precision: 5, scale: 2
    t.text "lab_result_notes"
    t.uuid "medical_record_id", null: false
    t.text "physical_examination"
    t.integer "respiration_rate"
    t.string "supporting_action"
    t.integer "systole"
    t.datetime "updated_at", null: false
    t.decimal "waist_circumference", precision: 5, scale: 2
    t.decimal "weight", precision: 5, scale: 2
    t.index ["medical_record_id"], name: "index_objective_examinations_on_medical_record_id"
  end

  create_table "odontograms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "notes"
    t.uuid "objective_examination_id", null: false
    t.jsonb "teeth_data", default: {}
    t.datetime "updated_at", null: false
    t.index ["objective_examination_id"], name: "index_odontograms_on_objective_examination_id"
  end

  create_table "patients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "address"
    t.text "allergies"
    t.date "birth_date"
    t.string "blood_type"
    t.datetime "created_at", null: false
    t.datetime "discraded_at"
    t.string "gender"
    t.string "name", null: false
    t.string "nik"
    t.string "patient_number"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["discraded_at"], name: "index_patients_on_discraded_at"
    t.index ["nik"], name: "index_patients_on_nik", unique: true
    t.index ["patient_number"], name: "index_patients_on_patient_number", unique: true
  end

  create_table "plan_treatments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "notes"
    t.uuid "plan_id", null: false
    t.decimal "price", precision: 12, scale: 2
    t.integer "quantity", default: 1
    t.string "tooth_number"
    t.uuid "treatment_catalog_id"
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_plan_treatments_on_plan_id"
    t.index ["treatment_catalog_id"], name: "index_plan_treatments_on_treatment_catalog_id"
  end

  create_table "plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "follow_up_plan"
    t.uuid "medical_record_id", null: false
    t.date "next_visit_date"
    t.datetime "updated_at", null: false
    t.index ["medical_record_id"], name: "index_plans_on_medical_record_id"
  end

  create_table "prescriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "dosage"
    t.string "drug_name", null: false
    t.string "duration"
    t.string "frequency"
    t.string "notes"
    t.uuid "plan_id", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_prescriptions_on_plan_id"
  end

  create_table "subjective_examinations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "chief_complaint"
    t.datetime "created_at", null: false
    t.uuid "medical_record_id", null: false
    t.text "present_illness_history"
    t.datetime "updated_at", null: false
    t.index ["medical_record_id"], name: "index_subjective_examinations_on_medical_record_id"
  end

  create_table "treatment_catalogs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "category"
    t.string "code"
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true
    t.string "name", null: false
    t.decimal "price", precision: 12, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_treatment_catalogs_on_code", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "clinic_address"
    t.string "clinic_name"
    t.string "clinic_phone"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "sip_number"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "chief_complaint"
    t.datetime "created_at", null: false
    t.uuid "patient_id", null: false
    t.string "status", default: "registered"
    t.datetime "updated_at", null: false
    t.datetime "visit_date", null: false
    t.string "visit_number"
    t.index ["patient_id"], name: "index_visits_on_patient_id"
    t.index ["visit_number"], name: "index_visits_on_visit_number", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointments", "patients"
  add_foreign_key "assessments", "medical_records"
  add_foreign_key "billing_items", "billings"
  add_foreign_key "billing_items", "plan_treatments"
  add_foreign_key "billings", "visits"
  add_foreign_key "medical_records", "visits"
  add_foreign_key "objective_examinations", "medical_records"
  add_foreign_key "odontograms", "objective_examinations"
  add_foreign_key "plan_treatments", "plans"
  add_foreign_key "plan_treatments", "treatment_catalogs"
  add_foreign_key "plans", "medical_records"
  add_foreign_key "prescriptions", "plans"
  add_foreign_key "subjective_examinations", "medical_records"
  add_foreign_key "visits", "patients"
end
