# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140920222433) do

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.string   "stripe_charge_id"
    t.string   "stripe_refund_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "product_orders", force: true do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.integer  "quantity"
    t.decimal  "purchase_price"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.string   "short_desc"
    t.integer  "best_selling_rank"
    t.string   "thumbnail"
    t.decimal  "price"
    t.string   "manufacturer"
    t.string   "url"
    t.string   "product_type"
    t.string   "image"
    t.string   "category"
    t.boolean  "free_shipping"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "shipments", force: true do |t|
    t.integer  "order_id"
    t.decimal  "price"
    t.string   "carrier"
    t.string   "tracking_code"
    t.boolean  "delivered"
    t.datetime "est_delivery_date"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "stripe_card_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
