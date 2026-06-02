# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.find_or_create_by!(email: "dokter@klinikgigi.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.name = "Dr. Gigi"
end

treatment_catalogs = [
  { code: "GG-001", name: "Konsultasi",                   category: "Umum" },
  { code: "GG-002", name: "Cabut Gigi Anak",              category: "Bedah" },
  { code: "GG-003", name: "Cabut Gigi Dewasa",            category: "Bedah" },
  { code: "GG-004", name: "Cabut Gigi dengan Komplikasi", category: "Bedah" },
  { code: "GG-005", name: "Tambal Sementara",             category: "Konservasi" },
  { code: "GG-006", name: "Tambal Permanen (Komposit)",   category: "Konservasi" },
  { code: "GG-007", name: "Tambal Permanen (Amalgam)",    category: "Konservasi" },
  { code: "GG-008", name: "Perawatan Saluran Akar (PSA)", category: "Endodonti" },
  { code: "GG-009", name: "Scaling (Ultrasonic)",         category: "Periodonti" },
  { code: "GG-010", name: "Rontgen Periapikal",            category: "Radiologi" },
  { code: "GG-011", name: "Rontgen Panoramik",             category: "Radiologi" },
  { code: "GG-012", name: "Incisi Abses",                  category: "Bedah" }
]

treatment_catalogs.each do |tc|
  TreatmentCatalog.find_or_create_by!(code: tc[:code]) do |t|
    t.name = tc[:name]
    t.category = tc[:category]
  end
end
