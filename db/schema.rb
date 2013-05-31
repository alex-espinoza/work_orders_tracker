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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130531004221) do

  create_table "order_responses", :force => true do |t|
    t.text     "response"
    t.string   "file_attachment"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "order_id"
    t.integer  "user_id"
  end

  create_table "orders", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "high_priority"
    t.string   "file_attachment"
    t.string   "status"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "team_id"
    t.integer  "manager_id"
    t.integer  "worker_id"
  end

  create_table "teams", :force => true do |t|
    t.string   "team_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "role"
    t.integer  "team_id"
    t.integer  "manager_id"
  end

end
