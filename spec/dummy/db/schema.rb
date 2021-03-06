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

ActiveRecord::Schema.define(version: 20141209131446) do

  create_table "bitsy_blockchain_notifications", force: true do |t|
    t.integer "value",                        null: false
    t.string  "transaction_hash",             null: false
    t.string  "input_address",                null: false
    t.integer "confirmations",    default: 0, null: false
    t.string  "secret",                       null: false
  end

  create_table "bitsy_payment_depots", force: true do |t|
    t.decimal  "min_payment",                               null: false
    t.decimal  "initial_tax_rate",                          null: false
    t.decimal  "added_tax_rate",                            null: false
    t.decimal  "balance_cache",               default: 0.0, null: false
    t.string   "owner_address"
    t.string   "address",                                   null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "tax_address"
    t.string   "uuid",                                      null: false
    t.decimal  "total_received_amount_cache", default: 0.0, null: false
    t.integer  "check_count",                 default: 0,   null: false
    t.datetime "checked_at"
  end

  add_index "bitsy_payment_depots", ["uuid"], name: "index_bitsy_payment_depots_on_uuid"

  create_table "bitsy_payment_transactions", force: true do |t|
    t.integer  "payment_depot_id",                      null: false
    t.decimal  "amount",                                null: false
    t.string   "receiving_address",                     null: false
    t.string   "payment_type",                          null: false
    t.integer  "confirmations",             default: 0, null: false
    t.string   "transaction_id",                        null: false
    t.string   "forwarding_transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
