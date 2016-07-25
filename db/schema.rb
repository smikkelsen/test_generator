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

ActiveRecord::Schema.define(:version => 20130603204006) do

  create_table "model_associations", :force => true do |t|
    t.integer  "model_test_id"
    t.string   "relationship_type",     :limit => 32
    t.integer  "related_model_test_id",               :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "model_associations", ["model_test_id"], :name => "index_model_associations_on_model_test_id"
  add_index "model_associations", ["related_model_test_id"], :name => "index_model_associations_on_related_model_test_id"

  create_table "model_columns", :force => true do |t|
    t.integer  "model_test_id"
    t.string   "name",          :limit => 32,                       :null => false
    t.boolean  "db_index"
    t.boolean  "required",                    :default => false
    t.boolean  "unique"
    t.boolean  "mass_assign",                 :default => true
    t.string   "min_length"
    t.string   "max_length"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "data_type",                   :default => "string"
    t.string   "unique_scope"
    t.boolean  "attr_accessor",               :default => false
  end

  add_index "model_columns", ["db_index"], :name => "index_model_columns_on_db_index"
  add_index "model_columns", ["mass_assign"], :name => "index_model_columns_on_mass_assign"
  add_index "model_columns", ["model_test_id"], :name => "index_model_columns_on_model_test_id"
  add_index "model_columns", ["unique"], :name => "index_model_columns_on_unique"

  create_table "model_tests", :force => true do |t|
    t.integer  "project_id"
    t.string   "name",        :limit => 32,                   :null => false
    t.text     "description"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "timestamps",                :default => true
  end

  add_index "model_tests", ["project_id"], :name => "index_model_tests_on_project_id"

  create_table "project_comments", :force => true do |t|
    t.integer  "project_id"
    t.text     "comment",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "project_comments", ["project_id"], :name => "index_project_comments_on_project_id"

  create_table "projects", :force => true do |t|
    t.string   "ip_address",      :limit => 16
    t.string   "name",            :limit => 32, :null => false
    t.text     "description"
    t.string   "project_manager", :limit => 32
    t.string   "developer",       :limit => 32
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

end
