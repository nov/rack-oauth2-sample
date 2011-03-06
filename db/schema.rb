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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110306035434) do

  create_table "access_tokens", :force => true do |t|
    t.integer  "account_id"
    t.integer  "client_id"
    t.string   "token"
    t.integer  "expires_in"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "auth_facebooks", :force => true do |t|
    t.integer  "account_id"
    t.string   "identifier",   :limit => 20
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorization_codes", :force => true do |t|
    t.integer  "account_id"
    t.integer  "client_id"
    t.string   "code"
    t.boolean  "approved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", :force => true do |t|
    t.integer  "account_id"
    t.string   "identifier"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
