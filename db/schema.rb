# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_03_01_105315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "about_us", force: :cascade do |t|
    t.string "title"
    t.string "phone_number"
    t.string "email"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "account_categories", force: :cascade do |t|
    t.integer "account_id"
    t.integer "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "account_groups_account_groups", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "account_groups_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_groups_group_id"], name: "index_account_groups_account_groups_on_account_groups_group_id"
    t.index ["account_id"], name: "index_account_groups_account_groups_on_account_id"
  end

  create_table "account_groups_groups", force: :cascade do |t|
    t.string "name"
    t.jsonb "settings"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "full_phone_number"
    t.integer "country_code"
    t.bigint "phone_number"
    t.string "email"
    t.boolean "activated", default: false, null: false
    t.string "device_id"
    t.text "unique_auth_id"
    t.string "password_digest"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_name"
    t.string "platform"
    t.string "user_type"
    t.integer "app_language_id"
    t.datetime "last_visit_at"
    t.boolean "is_blacklisted", default: false
    t.date "suspend_until"
    t.integer "status", default: 0, null: false
    t.integer "role_id"
    t.string "stripe_id"
    t.string "stripe_subscription_id"
    t.datetime "stripe_subscription_date"
    t.integer "gender"
    t.date "date_of_birth"
    t.integer "age"
    t.string "teacher_unique_id"
    t.string "guardian_email"
    t.integer "school_id"
    t.string "student_unique_id"
    t.string "employee_unique_id"
    t.string "guardian_name"
    t.string "guardian_contact_no"
    t.string "publication_house_name"
    t.string "bank_account_number"
    t.string "ifsc_code"
    t.string "pin"
    t.string "photo"
    t.boolean "is_reset", default: false
    t.string "one_time_pin"
    t.integer "school_class_id"
    t.integer "class_division_id"
    t.string "department"
    t.boolean "video_status", default: false
    t.boolean "assignment_status", default: false
    t.boolean "assignment_download", default: false
    t.integer "subject_ids", default: [], array: true
    t.integer "subject_teacher_ids", default: [], array: true
    t.integer "subject_teacher_class_ids", default: [], array: true
    t.integer "subject_teacher_division_ids", default: [], array: true
    t.boolean "ebook_status", default: false
    t.boolean "ebook_download", default: false
    t.index ["is_blacklisted"], name: "index_accounts_on_is_blacklisted"
  end

  create_table "achievements", force: :cascade do |t|
    t.string "title"
    t.date "achievement_date"
    t.text "detail"
    t.string "url"
    t.integer "profile_bio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.boolean "default_image", default: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.bigint "trackable_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "addressables", force: :cascade do |t|
    t.bigint "shipment_id", null: false
    t.text "address"
    t.text "address2"
    t.string "city"
    t.string "country"
    t.string "email"
    t.string "name"
    t.string "phone"
    t.text "instructions"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shipment_id"], name: "index_addressables_on_shipment_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.integer "addressble_id"
    t.string "addressble_type"
    t.integer "address_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role"
    t.integer "school_id"
    t.boolean "school_allow", default: false
    t.boolean "class_allow", default: false
    t.boolean "subject_allow", default: false
    t.boolean "assignment_allow", default: false
    t.boolean "video_allow", default: false
    t.boolean "account_allow", default: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "application_message_translations", force: :cascade do |t|
    t.bigint "application_message_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "message", null: false
    t.index ["application_message_id"], name: "index_4df4694a81c904bef7786f2b09342fde44adca5f"
    t.index ["locale"], name: "index_application_message_translations_on_locale"
  end

  create_table "application_messages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "arrival_windows", force: :cascade do |t|
    t.datetime "begin_at"
    t.datetime "end_at"
    t.boolean "exclude_begin", default: true
    t.boolean "exclude_end", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "addressable_id"
  end

  create_table "assignments", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "subject_id"
    t.integer "subject_management_id"
    t.integer "account_id"
    t.integer "class_division_id"
    t.integer "school_class_id"
    t.integer "school_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "colour"
    t.string "layout"
    t.string "page_size"
    t.string "scale"
    t.string "print_sides"
    t.integer "print_pages_from"
    t.integer "print_pages_to"
    t.integer "total_pages"
    t.boolean "is_expired", default: false
    t.integer "total_attachment_pages"
    t.string "pdf_url"
    t.boolean "is_printed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "files"
    t.integer "status"
    t.index ["account_id"], name: "index_attachments_on_account_id"
  end

  create_table "audio_podcasts", force: :cascade do |t|
    t.string "heading"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "audios", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "audio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_audios_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_audios_on_attached_item_type"
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.text "bio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "availabilities", force: :cascade do |t|
    t.bigint "service_provider_id"
    t.string "start_time"
    t.string "end_time"
    t.string "unavailable_start_time"
    t.string "unavailable_end_time"
    t.string "availability_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "timeslots"
    t.integer "available_slots_count"
    t.index ["service_provider_id"], name: "index_availabilities_on_service_provider_id"
  end

  create_table "black_list_users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_black_list_users_on_account_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "content_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_bookmarks_on_account_id"
    t.index ["content_id"], name: "index_bookmarks_on_content_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "currency", default: 0
  end

  create_table "bundles_ebooks", id: false, force: :cascade do |t|
    t.bigint "bx_block_bulk_uploading_bundle_id"
    t.bigint "bx_block_bulk_uploading_ebook_id"
    t.index ["bx_block_bulk_uploading_bundle_id", "bx_block_bulk_uploading_ebook_id"], name: "index_bundles_ebooks_on_bundle_and_ebook", unique: true
    t.index ["bx_block_bulk_uploading_bundle_id"], name: "index_bundles_ebooks_on_bx_block_bulk_uploading_bundle_id"
    t.index ["bx_block_bulk_uploading_ebook_id"], name: "index_bundles_ebooks_on_bx_block_bulk_uploading_ebook_id"
  end

  create_table "bx_block_annotations", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_appointment_management_booked_slots", force: :cascade do |t|
    t.bigint "order_id"
    t.string "start_time"
    t.string "end_time"
    t.bigint "service_provider_id"
    t.date "booking_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_attachment_file_attachments", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "colour"
    t.string "layout"
    t.string "page_size"
    t.string "scale"
    t.string "print_sides"
    t.integer "print_pages_from"
    t.integer "print_pages_to"
    t.integer "total_pages"
    t.boolean "is_expired", default: false
    t.integer "total_attachment_pages"
    t.string "pdf_url"
    t.boolean "is_printed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_bx_block_attachment_file_attachments_on_account_id"
  end

  create_table "bx_block_bulk_uploading_bundles", force: :cascade do |t|
    t.string "title", limit: 100, null: false
    t.text "description", null: false
    t.decimal "total_pricing", null: false
    t.string "formats_available"
    t.integer "books_count"
    t.json "cover_images"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "board"
    t.string "school_class_id"
    t.string "subject"
  end

  create_table "bx_block_bulk_uploading_ebooks", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.string "size"
    t.integer "pages"
    t.string "edition"
    t.string "publisher"
    t.date "publication_date"
    t.string "formats_available"
    t.string "language"
    t.text "description"
    t.decimal "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "excel_file"
    t.string "pdf"
    t.string "school_id"
    t.string "board"
    t.string "school_class_id"
    t.string "subject"
    t.string "commission_percentage"
    t.json "images"
    t.string "publisher_commission"
  end

  create_table "bx_block_dashboard_candidates", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_dashboardguests_companies", force: :cascade do |t|
    t.string "company_name"
    t.string "company_holder"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_dashboardguests_dashboard_guests", force: :cascade do |t|
    t.string "company_name"
    t.integer "invest_amount"
    t.date "date_of_invest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "company_id"
    t.bigint "account_id"
  end

  create_table "bx_block_datastorage_file_documents", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "document_type", default: 0
    t.bigint "account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_bx_block_datastorage_file_documents_on_account_id"
  end

  create_table "bx_block_download_downloadables", force: :cascade do |t|
    t.integer "reference_id", null: false
    t.string "reference_type"
    t.datetime "last_download_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_elasticsearch_articles", force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_invoice_bill_to_addresses", force: :cascade do |t|
    t.string "name"
    t.string "company_name"
    t.string "address"
    t.string "city"
    t.string "zip_code"
    t.string "phone_number"
    t.string "email"
    t.bigint "order_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_invoice_companies", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "zip_code"
    t.string "phone_number"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_invoice_invoice_items", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "invoice_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_invoice_invoices", force: :cascade do |t|
    t.bigint "order_id"
    t.string "invoice_number"
    t.date "invoice_date"
    t.float "total_amount"
    t.string "company_address"
    t.string "company_city"
    t.string "company_zip_code"
    t.string "company_phone_number"
    t.string "bill_to_name"
    t.string "bill_to_company_name"
    t.string "bill_to_address"
    t.string "bill_to_city"
    t.string "bill_to_zip_code"
    t.string "bill_to_phone_number"
    t.string "bill_to_email"
    t.string "item_name"
    t.float "item_unit_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_bx_block_invoice_invoices_on_order_id"
  end

  create_table "bx_block_invoice_items", force: :cascade do |t|
    t.bigint "order_id"
    t.string "item_name"
    t.float "item_unit_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_invoice_orders", force: :cascade do |t|
    t.string "order_number"
    t.datetime "order_date"
    t.string "customer_name"
    t.string "customer_address"
    t.string "customer_phone_number"
    t.string "email"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_multipageforms2_user_profiles", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "email"
    t.string "gender"
    t.string "country"
    t.integer "industry"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_associated_projects", force: :cascade do |t|
    t.integer "project_id"
    t.integer "associated_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_associateds", force: :cascade do |t|
    t.string "associated_with_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_awards", force: :cascade do |t|
    t.string "title"
    t.string "associated_with"
    t.string "issuer"
    t.datetime "issue_date"
    t.text "description"
    t.boolean "make_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_career_experience_employment_types", force: :cascade do |t|
    t.integer "career_experience_id"
    t.integer "employment_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_career_experience_industry", force: :cascade do |t|
    t.integer "career_experience_id"
    t.integer "industry_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_career_experience_system_experiences", force: :cascade do |t|
    t.integer "career_experience_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "system_experience_id"
  end

  create_table "bx_block_profile_career_experiences", force: :cascade do |t|
    t.string "job_title"
    t.date "start_date"
    t.date "end_date"
    t.string "company_name"
    t.text "description"
    t.string "add_key_achievements", default: [], array: true
    t.boolean "make_key_achievements_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "current_salary", default: "0.0"
    t.text "notice_period"
    t.date "notice_period_end_date"
    t.boolean "currently_working_here", default: false
  end

  create_table "bx_block_profile_courses", force: :cascade do |t|
    t.string "course_name"
    t.string "duration"
    t.string "year"
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_current_annual_salaries", force: :cascade do |t|
    t.string "current_annual_salary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_current_annual_salary_current_status", force: :cascade do |t|
    t.integer "current_status_id"
    t.integer "current_annual_salary_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_current_status", force: :cascade do |t|
    t.string "most_recent_job_title"
    t.string "company_name"
    t.text "notice_period"
    t.date "end_date"
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_current_status_employment_types", force: :cascade do |t|
    t.integer "current_status_id"
    t.integer "employment_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_current_status_industries", force: :cascade do |t|
    t.integer "current_status_id"
    t.integer "industry_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_custom_user_profile_fields", force: :cascade do |t|
    t.string "name"
    t.string "field_type"
    t.boolean "is_enable", default: true, null: false
    t.boolean "is_required", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_bx_block_profile_custom_user_profile_fields_on_name"
  end

  create_table "bx_block_profile_degree_educational_qualifications", force: :cascade do |t|
    t.integer "educational_qualification_id"
    t.integer "degree_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_degrees", force: :cascade do |t|
    t.string "degree_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_educational_qualification_field_study", force: :cascade do |t|
    t.integer "educational_qualification_id"
    t.integer "field_study_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_educational_qualifications", force: :cascade do |t|
    t.string "school_name"
    t.date "start_date"
    t.date "end_date"
    t.string "grades"
    t.text "description"
    t.boolean "make_grades_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_employment_types", force: :cascade do |t|
    t.string "employment_type_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_field_study", force: :cascade do |t|
    t.string "field_of_study"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_hobbies_and_interests", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.text "description"
    t.boolean "make_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_industries", force: :cascade do |t|
    t.string "industry_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_languages", force: :cascade do |t|
    t.string "language"
    t.string "proficiency"
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_profiles", force: :cascade do |t|
    t.string "country"
    t.string "address"
    t.string "postal_code"
    t.string "photo"
    t.bigint "phone_number"
    t.string "email"
    t.string "user_name"
    t.integer "gender"
    t.date "date_of_birth"
    t.integer "age"
    t.string "teacher_unique_id"
    t.string "guardian_email"
    t.integer "school_id"
    t.string "student_unique_id"
    t.string "employee_unique_id"
    t.string "guardian_name"
    t.string "guardian_contact_no"
    t.string "full_phone_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "account_id"
    t.string "publication_house_name"
  end

  create_table "bx_block_profile_projects", force: :cascade do |t|
    t.string "project_name"
    t.date "start_date"
    t.date "end_date"
    t.string "add_members"
    t.string "url"
    t.text "description"
    t.boolean "make_projects_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_publication_patents", force: :cascade do |t|
    t.string "title"
    t.string "publication"
    t.string "authors"
    t.string "url"
    t.text "description"
    t.boolean "make_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_system_experiences", force: :cascade do |t|
    t.string "system_experience"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_profile_test_score_and_courses", force: :cascade do |t|
    t.string "title"
    t.string "associated_with"
    t.string "score"
    t.datetime "test_date"
    t.text "description"
    t.boolean "make_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_splitpayments_orders", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_terms_and_conditions_terms_and_conditions", force: :cascade do |t|
    t.integer "account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description"
    t.string "name"
  end

  create_table "bx_block_terms_and_conditions_user_term_and_conditions", force: :cascade do |t|
    t.integer "account_id"
    t.integer "terms_and_condition_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_accepted"
  end

  create_table "careers", force: :cascade do |t|
    t.string "profession"
    t.boolean "is_current", default: false
    t.string "experience_from"
    t.string "experience_to"
    t.string "payscale"
    t.string "company_name"
    t.string "accomplishment", array: true
    t.integer "sector"
    t.integer "profile_bio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_reviews", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.string "comment"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["catalogue_id"], name: "index_catalogue_reviews_on_catalogue_id"
  end

  create_table "catalogue_tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_variant_colors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_variant_sizes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_variants", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.bigint "catalogue_variant_color_id"
    t.bigint "catalogue_variant_size_id"
    t.decimal "price"
    t.integer "stock_qty"
    t.boolean "on_sale"
    t.decimal "sale_price"
    t.decimal "discount_price"
    t.float "length"
    t.float "breadth"
    t.float "height"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "block_qty"
    t.index ["catalogue_id"], name: "index_catalogue_variants_on_catalogue_id"
    t.index ["catalogue_variant_color_id"], name: "index_catalogue_variants_on_catalogue_variant_color_id"
    t.index ["catalogue_variant_size_id"], name: "index_catalogue_variants_on_catalogue_variant_size_id"
  end

  create_table "catalogues", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "sub_category_id", null: false
    t.bigint "brand_id"
    t.string "name"
    t.string "sku"
    t.string "description"
    t.datetime "manufacture_date"
    t.float "length"
    t.float "breadth"
    t.float "height"
    t.integer "availability"
    t.integer "stock_qty"
    t.decimal "weight"
    t.float "price"
    t.boolean "recommended"
    t.boolean "on_sale"
    t.decimal "sale_price"
    t.decimal "discount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "block_qty"
    t.index ["brand_id"], name: "index_catalogues_on_brand_id"
    t.index ["category_id"], name: "index_catalogues_on_category_id"
    t.index ["sub_category_id"], name: "index_catalogues_on_sub_category_id"
  end

  create_table "catalogues_tags", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.bigint "catalogue_tag_id", null: false
    t.index ["catalogue_id"], name: "index_catalogues_tags_on_catalogue_id"
    t.index ["catalogue_tag_id"], name: "index_catalogues_tags_on_catalogue_tag_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "admin_user_id"
    t.integer "rank"
    t.string "light_icon"
    t.string "light_icon_active"
    t.string "light_icon_inactive"
    t.string "dark_icon"
    t.string "dark_icon_active"
    t.string "dark_icon_inactive"
    t.integer "identifier"
  end

  create_table "categories_sub_categories", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "sub_category_id", null: false
    t.index ["category_id"], name: "index_categories_sub_categories_on_category_id"
    t.index ["sub_category_id"], name: "index_categories_sub_categories_on_sub_category_id"
  end

  create_table "class_divisions", force: :cascade do |t|
    t.string "division_name"
    t.integer "school_class_id"
    t.integer "account_id"
    t.integer "department_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "school_id"
    t.string "department"
    t.integer "subject_ids", default: [], array: true
    t.integer "subject_teacher_ids", default: [], array: true
  end

  create_table "cod_values", force: :cascade do |t|
    t.bigint "shipment_id", null: false
    t.float "amount"
    t.string "currency", default: "RS"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shipment_id"], name: "index_cod_values_on_shipment_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "commentable_id"
    t.string "commentable_type"
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_comments_on_account_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "account_id"
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "issue"
    t.index ["account_id"], name: "index_contacts_on_account_id"
  end

  create_table "content_management_videos", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "video"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_content_management_videos_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_content_management_videos_on_attached_item_type"
  end

  create_table "content_texts", force: :cascade do |t|
    t.string "headline"
    t.string "content"
    t.string "hyperlink"
    t.string "affiliation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "content_types", force: :cascade do |t|
    t.string "name"
    t.integer "type"
    t.integer "identifier"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "content_videos", force: :cascade do |t|
    t.string "separate_section"
    t.string "headline"
    t.string "description"
    t.string "thumbnails"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contents", force: :cascade do |t|
    t.integer "sub_category_id"
    t.integer "category_id"
    t.integer "content_type_id"
    t.integer "language_id"
    t.integer "status"
    t.datetime "publish_date"
    t.boolean "archived", default: false
    t.boolean "feature_article"
    t.boolean "feature_video"
    t.string "searchable_text"
    t.integer "review_status"
    t.string "feedback"
    t.integer "admin_user_id"
    t.bigint "view_count", default: 0
    t.string "contentable_type"
    t.bigint "contentable_id"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_contents_on_author_id"
    t.index ["contentable_type", "contentable_id"], name: "index_contents_on_contentable_type_and_contentable_id"
  end

  create_table "contents_languages", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "language_options_language_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_contents_languages_on_account_id"
    t.index ["language_options_language_id"], name: "index_contents_languages_on_language_options_language_id"
  end

  create_table "coordinates", force: :cascade do |t|
    t.string "latitude"
    t.string "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "addressable_id"
  end

  create_table "coupon_codes", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "code"
    t.string "discount_type", default: "flat"
    t.decimal "discount"
    t.datetime "valid_from"
    t.datetime "valid_to"
    t.decimal "min_cart_value"
    t.decimal "max_cart_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "create_shipments", force: :cascade do |t|
    t.boolean "auto_assign_drivers", default: false
    t.string "requested_by"
    t.string "shipper_id"
    t.string "waybill"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cta", force: :cascade do |t|
    t.string "headline"
    t.text "description"
    t.bigint "category_id"
    t.string "long_background_image"
    t.string "square_background_image"
    t.string "button_text"
    t.string "redirect_url"
    t.integer "text_alignment"
    t.integer "button_alignment"
    t.boolean "is_square_cta"
    t.boolean "is_long_rectangle_cta"
    t.boolean "is_text_cta"
    t.boolean "is_image_cta"
    t.boolean "has_button"
    t.boolean "visible_on_home_page"
    t.boolean "visible_on_details_page"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_cta_on_category_id"
  end

  create_table "deliveries", force: :cascade do |t|
    t.bigint "shipment_id", null: false
    t.text "address"
    t.text "address2"
    t.string "city"
    t.string "country"
    t.string "email"
    t.string "name"
    t.string "phone"
    t.text "instructions"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shipment_id"], name: "index_deliveries_on_shipment_id"
  end

  create_table "delivery_address_orders", force: :cascade do |t|
    t.bigint "order_management_order_id", null: false
    t.bigint "delivery_address_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["delivery_address_id"], name: "index_delivery_address_orders_on_delivery_address_id"
    t.index ["order_management_order_id"], name: "index_delivery_address_orders_on_order_management_order_id"
  end

  create_table "delivery_addresses", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "address"
    t.string "name"
    t.string "flat_no"
    t.string "zip_code"
    t.string "phone_number"
    t.datetime "deleted_at"
    t.float "latitude"
    t.float "longitude"
    t.boolean "residential", default: true
    t.string "city"
    t.string "state_code"
    t.string "country_code"
    t.string "state"
    t.string "country"
    t.string "address_line_2"
    t.string "address_type", default: "home"
    t.string "address_for", default: "shipping"
    t.boolean "is_default", default: false
    t.string "landmark"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_delivery_addresses_on_account_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.integer "school_class_id"
    t.integer "account_id"
    t.string "class_division"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "school_id"
    t.integer "class_division_id"
  end

  create_table "dimensions", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.float "height"
    t.float "length"
    t.float "width"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_dimensions_on_item_id"
  end

  create_table "ebook_allotments", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "ebook_id", null: false
    t.date "alloted_date"
    t.bigint "student_id"
    t.boolean "download", default: false
    t.date "downloaded_date"
    t.string "status"
    t.boolean "completed", default: false
    t.integer "school_class_id"
    t.integer "class_division_id"
    t.integer "school_id"
    t.index ["account_id"], name: "index_ebook_allotments_on_account_id"
    t.index ["ebook_id"], name: "index_ebook_allotments_on_ebook_id"
  end

  create_table "educations", force: :cascade do |t|
    t.string "qualification"
    t.integer "profile_bio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "year_from"
    t.string "year_to"
    t.text "description"
  end

  create_table "email_otps", force: :cascade do |t|
    t.string "email"
    t.integer "pin"
    t.boolean "activated", default: false, null: false
    t.datetime "valid_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "epubs", force: :cascade do |t|
    t.string "heading"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "exams", force: :cascade do |t|
    t.string "heading"
    t.text "description"
    t.date "to"
    t.date "from"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "faq_questions", force: :cascade do |t|
    t.string "question"
    t.text "answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "favourites", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "favouriteable_id"
    t.string "favouriteable_type"
    t.integer "user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "content_provider_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_follows_on_account_id"
    t.index ["content_provider_id"], name: "index_follows_on_content_provider_id"
  end

  create_table "images", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_images_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_images_on_attached_item_type"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "shipment_id", null: false
    t.string "ref_id"
    t.float "weight"
    t.integer "quantity"
    t.boolean "stackable", default: true
    t.integer "item_type", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shipment_id"], name: "index_items_on_shipment_id"
  end

  create_table "language_options_languages", force: :cascade do |t|
    t.string "name"
    t.string "language_code"
    t.boolean "is_content_language"
    t.boolean "is_app_language"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "like_by_id"
    t.string "likeable_type", null: false
    t.bigint "likeable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id"
  end

  create_table "live_streams", force: :cascade do |t|
    t.string "headline"
    t.string "description"
    t.string "comment_section"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.integer "van_id"
    t.text "address"
    t.string "locationable_type"
    t.bigint "locationable_id"
    t.index ["locationable_type", "locationable_id"], name: "index_locations_on_locationable_type_and_locationable_id"
  end

  create_table "navigation_menus", force: :cascade do |t|
    t.string "position", comment: "Where will this navigation item be present"
    t.json "items", comment: "Navigation Menu Items, combination of url and name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_management_order_id", null: false
    t.integer "quantity"
    t.decimal "unit_price"
    t.decimal "total_price"
    t.decimal "old_unit_price"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "catalogue_id"
    t.bigint "catalogue_variant_id"
    t.integer "order_status_id"
    t.datetime "placed_at"
    t.datetime "confirmed_at"
    t.datetime "in_transit_at"
    t.datetime "delivered_at"
    t.datetime "cancelled_at"
    t.datetime "refunded_at"
    t.boolean "manage_placed_status", default: false
    t.boolean "manage_cancelled_status", default: false
    t.integer "ebook_id"
    t.integer "bundle_management_id"
    t.index ["catalogue_id"], name: "index_order_items_on_catalogue_id"
    t.index ["catalogue_variant_id"], name: "index_order_items_on_catalogue_variant_id"
    t.index ["order_management_order_id"], name: "index_order_items_on_order_management_order_id"
  end

  create_table "order_management_orders", force: :cascade do |t|
    t.string "order_number"
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.bigint "coupon_code_id"
    t.bigint "delivery_address_id"
    t.decimal "sub_total", default: "0.0"
    t.decimal "total", default: "0.0"
    t.string "status"
    t.decimal "applied_discount", default: "0.0"
    t.text "cancellation_reason"
    t.datetime "order_date"
    t.boolean "is_gift", default: false
    t.datetime "placed_at"
    t.datetime "confirmed_at"
    t.datetime "in_transit_at"
    t.datetime "delivered_at"
    t.datetime "cancelled_at"
    t.datetime "refunded_at"
    t.string "source"
    t.string "shipment_id"
    t.string "delivery_charges"
    t.string "tracking_url"
    t.datetime "schedule_time"
    t.datetime "payment_failed_at"
    t.datetime "returned_at"
    t.decimal "tax_charges", default: "0.0"
    t.integer "deliver_by"
    t.string "tracking_number"
    t.boolean "is_error", default: false
    t.string "delivery_error_message"
    t.datetime "payment_pending_at"
    t.integer "order_status_id"
    t.boolean "is_group", default: true
    t.boolean "is_availability_checked", default: false
    t.decimal "shipping_charge"
    t.decimal "shipping_discount"
    t.decimal "shipping_net_amt"
    t.decimal "shipping_total"
    t.float "total_tax"
    t.string "razorpay_order_id"
    t.boolean "charged"
    t.boolean "invoiced"
    t.string "invoice_id"
    t.string "custom_label"
    t.index ["account_id"], name: "index_order_management_orders_on_account_id"
    t.index ["coupon_code_id"], name: "index_order_management_orders_on_coupon_code_id"
  end

  create_table "order_statuses", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.boolean "active", default: true
    t.string "event_name"
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "order_trackings", force: :cascade do |t|
    t.string "parent_type"
    t.bigint "parent_id"
    t.integer "tracking_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_type", "parent_id"], name: "index_order_trackings_on_parent_type_and_parent_id"
  end

  create_table "order_transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "order_management_order_id", null: false
    t.string "charge_id"
    t.integer "amount"
    t.string "currency"
    t.string "charge_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_order_transactions_on_account_id"
    t.index ["order_management_order_id"], name: "index_order_transactions_on_order_management_order_id"
  end

  create_table "pdfs", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "pdf"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_pdfs_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_pdfs_on_attached_item_type"
  end

  create_table "pickups", force: :cascade do |t|
    t.bigint "shipment_id", null: false
    t.text "address"
    t.text "address2"
    t.string "city"
    t.string "country"
    t.string "email"
    t.string "name"
    t.string "phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shipment_id"], name: "index_pickups_on_shipment_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.integer "duration"
    t.float "price"
    t.text "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "body"
    t.string "location"
    t.integer "account_id"
    t.bigint "sub_category_id"
    t.index ["category_id"], name: "index_posts_on_category_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.integer "seeking"
    t.string "discover_people", array: true
    t.text "location"
    t.integer "distance"
    t.integer "height_type"
    t.integer "body_type"
    t.integer "religion"
    t.integer "smoking"
    t.integer "drinking"
    t.integer "profile_bio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "friend", default: false
    t.boolean "business", default: false
    t.boolean "match_making", default: false
    t.boolean "travel_partner", default: false
    t.boolean "cross_path", default: false
    t.integer "age_range_start"
    t.integer "age_range_end"
    t.string "height_range_start"
    t.string "height_range_end"
    t.integer "account_id"
  end

  create_table "print_prices", force: :cascade do |t|
    t.string "page_size"
    t.string "colors"
    t.float "single_side"
    t.float "double_side"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "profile_bios", force: :cascade do |t|
    t.integer "account_id"
    t.string "height"
    t.string "weight"
    t.integer "height_type"
    t.integer "weight_type"
    t.integer "body_type"
    t.integer "mother_tougue"
    t.integer "religion"
    t.integer "zodiac"
    t.integer "marital_status"
    t.string "languages", array: true
    t.text "about_me"
    t.string "personality", array: true
    t.string "interests", array: true
    t.integer "smoking"
    t.integer "drinking"
    t.integer "looking_for"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "about_business"
    t.jsonb "custom_attributes"
  end

  create_table "push_notifications", force: :cascade do |t|
    t.bigint "account_id"
    t.string "push_notificable_type", null: false
    t.bigint "push_notificable_id", null: false
    t.string "remarks"
    t.boolean "is_read", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "notify_type"
    t.index ["account_id"], name: "index_push_notifications_on_account_id"
    t.index ["push_notificable_type", "push_notificable_id"], name: "index_push_notification_type_and_id"
  end

  create_table "remove_books", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "ebook_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_remove_books_on_account_id"
    t.index ["ebook_id"], name: "index_remove_books_on_ebook_id"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "status", default: 0
    t.integer "account_group_id"
    t.string "request_text"
    t.string "rejection_reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "school_classes", force: :cascade do |t|
    t.integer "school_id"
    t.integer "class_number"
    t.string "class_division"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "account_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "board"
    t.string "phone_number"
    t.string "email"
    t.string "principal_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "title"
    t.string "name"
  end

  create_table "shipment_values", force: :cascade do |t|
    t.bigint "shipment_id", null: false
    t.float "amount"
    t.string "currency"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shipment_id"], name: "index_shipment_values_on_shipment_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.bigint "create_shipment_id", null: false
    t.string "ref_id"
    t.boolean "full_truck", default: false
    t.text "load_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["create_shipment_id"], name: "index_shipments_on_create_shipment_id"
  end

  create_table "shopping_cart_order_items", force: :cascade do |t|
    t.integer "order_id"
    t.integer "catalogue_id"
    t.float "price"
    t.integer "quantity", default: 0
    t.boolean "taxable", default: false
    t.float "taxable_value", default: 0.0
    t.float "other_charges"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shopping_cart_orders", force: :cascade do |t|
    t.bigint "customer_id"
    t.integer "address_id"
    t.integer "status"
    t.float "total_fees"
    t.integer "total_items"
    t.float "total_tax"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_split", default: false
    t.text "split_detail"
    t.index ["customer_id"], name: "index_shopping_cart_orders_on_customer_id"
  end

  create_table "sms_otps", force: :cascade do |t|
    t.string "full_phone_number"
    t.integer "pin"
    t.boolean "activated", default: false, null: false
    t.datetime "valid_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "student_videos", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "videos_lecture_id"
    t.boolean "status", default: false
    t.index ["account_id"], name: "index_student_videos_on_account_id"
    t.index ["videos_lecture_id"], name: "index_student_videos_on_videos_lecture_id"
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_id"
    t.integer "rank"
  end

  create_table "subject_managements", force: :cascade do |t|
    t.integer "subject_id"
    t.integer "account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "class_division_id"
    t.string "videos_lecture"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "subject_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "class_division_id"
    t.integer "account_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tests", force: :cascade do |t|
    t.text "description"
    t.string "headline"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "trackings", force: :cascade do |t|
    t.string "status"
    t.string "tracking_number"
    t.datetime "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "order_id"
    t.string "razorpay_order_id"
    t.string "razorpay_payment_id"
    t.string "razorpay_signature"
    t.integer "account_id"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_split", default: false
    t.text "split_detail"
  end

  create_table "user_categories", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_user_categories_on_account_id"
    t.index ["category_id"], name: "index_user_categories_on_category_id"
  end

  create_table "user_sub_categories", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "sub_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_user_sub_categories_on_account_id"
    t.index ["sub_category_id"], name: "index_user_sub_categories_on_sub_category_id"
  end

  create_table "van_members", force: :cascade do |t|
    t.integer "account_id"
    t.integer "van_id"
  end

  create_table "vans", force: :cascade do |t|
    t.string "name"
    t.text "bio"
    t.boolean "is_offline"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "videos_uploads", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "subject"
    t.string "video"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "subject_id"
    t.integer "subject_management_id"
    t.integer "account_id"
    t.string "video_duration"
    t.integer "class_division_id"
    t.integer "school_class_id"
    t.integer "school_id"
    t.integer "time_hour"
    t.integer "time_min"
  end

  create_table "view_profiles", force: :cascade do |t|
    t.integer "profile_bio_id"
    t.integer "view_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "account_id"
  end

  add_foreign_key "account_groups_account_groups", "account_groups_groups"
  add_foreign_key "account_groups_account_groups", "accounts"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addressables", "shipments"
  add_foreign_key "attachments", "accounts"
  add_foreign_key "black_list_users", "accounts"
  add_foreign_key "bookmarks", "accounts"
  add_foreign_key "bookmarks", "contents"
  add_foreign_key "bx_block_attachment_file_attachments", "accounts"
  add_foreign_key "bx_block_datastorage_file_documents", "accounts"
  add_foreign_key "catalogue_reviews", "catalogues"
  add_foreign_key "catalogue_variants", "catalogue_variant_colors"
  add_foreign_key "catalogue_variants", "catalogue_variant_sizes"
  add_foreign_key "catalogue_variants", "catalogues"
  add_foreign_key "catalogues", "brands"
  add_foreign_key "catalogues", "categories"
  add_foreign_key "catalogues", "sub_categories"
  add_foreign_key "catalogues_tags", "catalogue_tags"
  add_foreign_key "catalogues_tags", "catalogues"
  add_foreign_key "categories_sub_categories", "categories"
  add_foreign_key "categories_sub_categories", "sub_categories"
  add_foreign_key "cod_values", "shipments"
  add_foreign_key "comments", "accounts"
  add_foreign_key "contents", "authors"
  add_foreign_key "contents_languages", "accounts"
  add_foreign_key "contents_languages", "language_options_languages"
  add_foreign_key "deliveries", "shipments"
  add_foreign_key "delivery_address_orders", "delivery_addresses"
  add_foreign_key "delivery_address_orders", "order_management_orders"
  add_foreign_key "delivery_addresses", "accounts"
  add_foreign_key "dimensions", "items"
  add_foreign_key "ebook_allotments", "accounts"
  add_foreign_key "ebook_allotments", "bx_block_bulk_uploading_ebooks", column: "ebook_id"
  add_foreign_key "follows", "accounts"
  add_foreign_key "items", "shipments"
  add_foreign_key "order_items", "catalogue_variants"
  add_foreign_key "order_items", "catalogues"
  add_foreign_key "order_items", "order_management_orders"
  add_foreign_key "order_transactions", "accounts"
  add_foreign_key "order_transactions", "order_management_orders"
  add_foreign_key "pickups", "shipments"
  add_foreign_key "posts", "categories"
  add_foreign_key "push_notifications", "accounts"
  add_foreign_key "remove_books", "accounts"
  add_foreign_key "remove_books", "bx_block_bulk_uploading_ebooks", column: "ebook_id"
  add_foreign_key "shipment_values", "shipments"
  add_foreign_key "shipments", "create_shipments"
  add_foreign_key "taggings", "tags"
  add_foreign_key "user_categories", "accounts"
  add_foreign_key "user_categories", "categories"
  add_foreign_key "user_sub_categories", "accounts"
  add_foreign_key "user_sub_categories", "sub_categories"
end
