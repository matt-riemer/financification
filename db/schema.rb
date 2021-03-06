# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180129174242) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "addressable_type"
    t.integer "addressable_id"
    t.string "category", limit: 64
    t.string "full_name"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state_code"
    t.string "country_code"
    t.string "postal_code"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["addressable_id"], name: "index_addresses_on_addressable_id"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
  end

  create_table "assets", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "extra"
    t.integer "user_id"
    t.string "content_type"
    t.text "upload_file"
    t.string "data"
    t.boolean "processed", default: false
    t.string "aws_acl", default: "public-read"
    t.integer "data_size"
    t.integer "height"
    t.integer "width"
    t.text "versions_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["content_type"], name: "index_assets_on_content_type"
    t.index ["user_id"], name: "index_assets_on_user_id"
  end

  create_table "attachments", id: :serial, force: :cascade do |t|
    t.integer "asset_id"
    t.string "attachable_type"
    t.integer "attachable_id"
    t.integer "position"
    t.string "box"
    t.index ["asset_id"], name: "index_attachments_on_asset_id"
    t.index ["attachable_id"], name: "index_attachments_on_attachable_id"
    t.index ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id"
  end

  create_table "cart_items", id: :serial, force: :cascade do |t|
    t.integer "cart_id"
    t.string "purchasable_type"
    t.integer "purchasable_id"
    t.integer "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["purchasable_id"], name: "index_cart_items_on_purchasable_id"
    t.index ["purchasable_type", "purchasable_id"], name: "index_cart_items_on_purchasable_type_and_purchasable_id"
  end

  create_table "carts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "category_group_id"
    t.string "name"
    t.integer "position"
    t.boolean "debit"
    t.boolean "credit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["category_group_id"], name: "index_categories_on_category_group_id"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "category_groups", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.boolean "debit"
    t.boolean "credit"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_category_groups_on_user_id"
  end

  create_table "customers", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "stripe_customer_id"
    t.string "stripe_active_card"
    t.string "stripe_connect_access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "imports", force: :cascade do |t|
    t.bigint "account_id"
    t.text "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "status"
    t.index ["account_id"], name: "index_imports_on_account_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "category_id"
    t.bigint "rule_id"
    t.bigint "import_id"
    t.string "name"
    t.date "date"
    t.integer "debit"
    t.integer "credit"
    t.integer "balance"
    t.text "note"
    t.text "original"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_items_on_account_id"
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["import_id"], name: "index_items_on_import_id"
    t.index ["rule_id"], name: "index_items_on_rule_id"
  end

  create_table "logs", id: :serial, force: :cascade do |t|
    t.integer "parent_id"
    t.integer "user_id"
    t.string "associated_type"
    t.integer "associated_id"
    t.string "associated_to_s"
    t.integer "logs_count"
    t.string "message"
    t.text "details"
    t.string "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["associated_id"], name: "index_logs_on_associated_id"
    t.index ["associated_type", "associated_id"], name: "index_logs_on_associated_type_and_associated_id"
    t.index ["parent_id"], name: "index_logs_on_parent_id"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "menu_items", id: :serial, force: :cascade do |t|
    t.integer "menu_id"
    t.integer "menuable_id"
    t.string "menuable_type"
    t.string "title"
    t.string "url"
    t.string "special"
    t.string "classes"
    t.boolean "new_window", default: false
    t.integer "roles_mask"
    t.integer "lft"
    t.integer "rgt"
    t.index ["lft"], name: "index_menu_items_on_lft"
  end

  create_table "menus", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_items", id: :serial, force: :cascade do |t|
    t.integer "order_id"
    t.integer "seller_id"
    t.string "purchasable_type"
    t.integer "purchasable_id"
    t.string "title"
    t.integer "quantity"
    t.integer "price", default: 0
    t.boolean "tax_exempt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["purchasable_id"], name: "index_order_items_on_purchasable_id"
    t.index ["purchasable_type", "purchasable_id"], name: "index_order_items_on_purchasable_type_and_purchasable_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "purchase_state"
    t.datetime "purchased_at"
    t.text "note"
    t.text "note_to_buyer"
    t.text "note_internal"
    t.text "payment"
    t.string "payment_provider"
    t.string "payment_card"
    t.decimal "tax_rate", precision: 6, scale: 3
    t.integer "subtotal"
    t.integer "tax"
    t.integer "total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "meta_description"
    t.boolean "draft", default: false
    t.string "layout", default: "application"
    t.string "template"
    t.string "slug"
    t.integer "roles_mask", default: 0
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["slug"], name: "index_pages_on_slug", unique: true
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.string "category"
    t.boolean "draft", default: false
    t.datetime "published_at"
    t.text "tags"
    t.integer "roles_mask", default: 0
    t.datetime "start_at"
    t.datetime "end_at"
    t.string "location"
    t.string "website_name"
    t.string "website_href"
    t.text "extra"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "price", default: 0
    t.boolean "tax_exempt", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", id: :serial, force: :cascade do |t|
    t.string "regionable_type"
    t.integer "regionable_id"
    t.string "title"
    t.text "content"
    t.text "snippets"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["regionable_id"], name: "index_regions_on_regionable_id"
    t.index ["regionable_type", "regionable_id"], name: "index_regions_on_regionable_type_and_regionable_id"
  end

  create_table "rules", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "import_id"
    t.bigint "user_id"
    t.string "title"
    t.boolean "match_name"
    t.string "name"
    t.boolean "match_note"
    t.string "note"
    t.boolean "match_amount"
    t.integer "amount_min"
    t.integer "amount_max"
    t.boolean "match_date"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["category_id"], name: "index_rules_on_category_id"
    t.index ["import_id"], name: "index_rules_on_import_id"
    t.index ["user_id"], name: "index_rules_on_user_id"
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.integer "customer_id"
    t.string "stripe_plan_id"
    t.string "stripe_subscription_id"
    t.string "stripe_coupon_id"
    t.string "title"
    t.integer "price", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["customer_id"], name: "index_subscriptions_on_customer_id"
    t.index ["stripe_subscription_id"], name: "index_subscriptions_on_stripe_subscription_id"
  end

  create_table "trash", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "trashed_type"
    t.integer "trashed_id"
    t.string "trashed_to_s"
    t.string "trashed_extra"
    t.text "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["trashed_extra"], name: "index_trash_on_trashed_extra"
    t.index ["trashed_id"], name: "index_trash_on_trashed_id"
    t.index ["trashed_type", "trashed_id"], name: "index_trash_on_trashed_type_and_trashed_id"
    t.index ["user_id"], name: "index_trash_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "roles_mask"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
