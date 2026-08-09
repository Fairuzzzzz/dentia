<div align="center">
  <h1>Dentia</h1>
  <p><strong>Dental Clinic Management Information System</strong></p>
  <p>A web application for solo dental practitioners in Indonesia</p>
</div>

---

## Features

- **Multi-User Authentication** — Account registration, login, change password, delete account
- **Patient Data** — Patient CRUD, search (name/NIK/phone), random 5-digit medical record number
- **SOAP Medical Records** — Complete form with Subjective, Objective (vital signs, odontogram), Assessment (ICD-10), Plan (prescriptions + treatments)
- **Interactive SVG Odontogram** — 32 permanent teeth (FDI) + 20 primary teeth, select status (caries, filling, extraction, etc.) with 5 surfaces, save/cancel panel
- **Treatment Catalog** — Dental procedure master data (code, name, category)
- **Visits** — Visit management with status (registered → in progress → completed), auto-billing on completion
- **Scheduling** — Monthly calendar, create/edit appointments, auto-appointment from next visit
- **Billing** — Auto-generated billing from treatments, record payments (cash/transfer/BPJS/insurance)
- **Dashboard** — Daily statistics (visits, new patients, revenue), 7-day chart, shortcuts
- **Reports** — Date filter, visit/patient/revenue summary, PDF & Excel export (4 sheets)
- **Prescription & Invoice Printing** — PDF via Prawn with clinic header, A5/A4 format
- **Dark Mode** — Toggle dark theme, persisted to localStorage
- **Multi Language** — Indonesian / English (real-time switching)
- **Mobile Responsive** — Hamburger sidebar, horizontal-scroll tables, dynamic grid
- **Soft Delete** — Patient data is never permanently lost (Discard gem)
- **ICD-10 Autocomplete** — Search dental diagnosis codes (K00–K14) in the Assessment form

---

## Tech Stack

| Technology | Purpose |
|-----------|---------|
| **Ruby on Rails 8.1** | Full-stack framework |
| **Hotwire** (Turbo + Stimulus) | Interactive frontend without React/Vue |
| **Tailwind CSS v4** | Utility-first styling |
| **PostgreSQL 16** | Database |
| **Devise** | Authentication |
| **Prawn + Prawn-Table** | PDF export (prescriptions, invoices, reports) |
| **Caxlsx + Caxlsx-Rails** | Excel export (4-sheet report) |
| **Pagy** | Pagination |
| **Ransack** | Search & filter |
| **Discard** | Soft delete |
| **Lucide-Rails** | Icons |
| **Solid Queue** | Background jobs (built into Rails 8) |
| **Docker** | PostgreSQL container |

---

## Prerequisites

- **Ruby** 3.4+
- **Bundler**
- **Docker** (for PostgreSQL)
- **Node.js** (for importmap)

---

## Installation & Running

### 1. Clone the repository

```bash
git clone https://github.com/Fairuzzzzz/dentia.git
cd dentia
```

### 2. Set up environment variables

```bash
cp .env.example .env
```

Fill in the `.env` file:
```env
DB_USERNAME=dentia
DB_PASSWORD=dentia_password
DB_NAME=dentia_development
```

### 3. Start PostgreSQL via Docker

```bash
docker compose up -d
```

### 4. Install dependencies

```bash
bundle install
```

### 5. Set up the database

```bash
rails db:create db:migrate db:seed
```

### 6. Run the application

```bash
bin/dev
```

Access in your browser: **http://localhost:3000**

### Default Account (seed)

| Email | Password |
|-------|----------|
| `dokter@klinikgigi.com` | `password123` |

---

## Docker Setup Details

`compose.yaml` runs PostgreSQL 16 with configuration from the `.env` file:

```yaml
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_USER: ${DB_USERNAME}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
```

Database data persists in the `postgres_data` volume.

---

## Database Structure

### Entity Relationship Diagram

```
patients ──┬── visits ──── medical_records ──┬── subjective_examinations
           │                                 ├── objective_examinations ── odontograms
           │                                 ├── assessments
           │                                 └── plans ──┬── prescriptions
           │                                             └── plan_treatments ── treatment_catalogs
           ├── appointments
           └── (user_id)

visits ──── billings ──── billing_items ──── plan_treatments
```

### Main Tables (14 tables)

| Table | Description |
|-------|------------|
| `users` | Doctor accounts |
| `patients` | Patient data (soft delete via discard) |
| `visits` | Patient visits |
| `medical_records` | Medical records (1 per visit) |
| `subjective_examinations` | S — Subjective (complaints, history) |
| `objective_examinations` | O — Objective (vital signs, physical exam) |
| `odontograms` | Tooth data (JSONB) |
| `assessments` | A — Assessment (ICD-10, diagnosis) |
| `plans` | P — Plan (prescriptions, treatments, follow-up) |
| `prescriptions` | Medications/prescriptions |
| `plan_treatments` | Treatments per plan |
| `treatment_catalogs` | Treatment catalog (master data) |
| `appointments` | Appointments |
| `billings` | Billing |
| `billing_items` | Billing details per treatment |
| `icd_codes` | ICD-10 dental diagnosis codes (K00–K14) |

---

## Directory Structure

```
app/
├── controllers/
│   ├── application_controller.rb
│   ├── dashboard_controller.rb
│   ├── patients_controller.rb
│   ├── visits_controller.rb
│   ├── treatment_catalogs_controller.rb
│   ├── appointments_controller.rb
│   ├── billings_controller.rb
│   ├── reports_controller.rb
│   ├── profiles_controller.rb
│   ├── icd_codes_controller.rb
│   ├── settings/
│   │   └── preferences_controller.rb
│   └── users/
│       └── registrations_controller.rb
├── models/
│   ├── user.rb, patient.rb, visit.rb, medical_record.rb
│   ├── subjective_examination.rb, objective_examination.rb
│   ├── odontogram.rb, assessment.rb, plan.rb
│   ├── prescription.rb, plan_treatment.rb
│   ├── treatment_catalog.rb, appointment.rb
│   ├── billing.rb, billing_item.rb, icd_code.rb
├── views/
│   ├── layouts/application.html.erb
│   ├── shared/_sidebar.html.erb, _flash.html.erb
│   ├── dashboard/, patients/, visits/
│   ├── treatment_catalogs/, appointments/
│   ├── billings/, reports/, profiles/
│   ├── settings/preferences/
│   └── devise/ (sessions, registrations)
└── javascript/controllers/
    ├── index.js
    ├── odontogram_controller.js
    ├── dark_mode_controller.js
    ├── mobile_menu_controller.js
    ├── nested_form_controller.js
    ├── icd_autocomplete_controller.js
```

---

## Roadmap

- [x] **ICD-10 Autocomplete** — Dental diagnosis codes in the Assessment form
- [ ] **Prescription Templates** — Standard-dosage prescriptions for quick selection
- [ ] **Patient History** — Complete history tab (visits, billing, odontogram)
- [ ] **Notifications** — Appointment reminders via email/WhatsApp
- [ ] **Multi-Clinic** — Support for multiple clinics in one account
- [ ] **API** — REST API for integration with other systems
- [ ] **CI/CD** — GitHub Actions for automated testing

---

## Screenshots

| | |
|:---:|:---:|
| ![Dashboard](screenshots/Dashboard.png) | ![Visit Detail](screenshots/Detail_Kunjungan.png) |
| **Dashboard** — Daily summary, chart, shortcuts | **SOAP Form** — Subjective, Objective, Assessment, Plan |
| ![Scheduling](screenshots/Penjadwalan.png) | ![Register](screenshots/Register.png) |
| **Calendar** — Monthly appointments | **Register** — New account registration |

---

## License

MIT License — free to use, modify, and distribute.

---

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature-name`)
3. Commit your changes (`git commit -m 'Add awesome feature'`)
4. Push to the branch (`git push origin feature-name`)
5. Open a Pull Request
