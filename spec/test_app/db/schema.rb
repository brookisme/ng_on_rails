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

ActiveRecord::Schema.define(version: 20141003143822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "docs", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.integer  "doc_id"
    t.string   "subject"
    t.text     "body"
    t.integer  "order_index"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["doc_id"], name: "index_pages_on_doc_id", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.integer  "order"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_link_conditions", force: true do |t|
    t.integer  "reporter_id"
    t.integer  "order_index"
    t.string   "property"
    t.string   "operator"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_link_conditions", ["reporter_id"], name: "index_survey_link_conditions_on_reporter_id", using: :btree

  create_table "survey_link_doc_groups", force: true do |t|
    t.integer  "group_id"
    t.integer  "doc_id"
    t.integer  "doc_version_id"
    t.integer  "doc_order"
    t.boolean  "doc_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_link_doc_groups", ["doc_id"], name: "index_survey_link_doc_groups_on_doc_id", using: :btree
  add_index "survey_link_doc_groups", ["doc_version_id"], name: "index_survey_link_doc_groups_on_doc_version_id", using: :btree
  add_index "survey_link_doc_groups", ["group_id"], name: "index_survey_link_doc_groups_on_group_id", using: :btree

  create_table "survey_link_doc_pages", force: true do |t|
    t.integer  "doc_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_link_doc_pages", ["doc_id"], name: "index_survey_link_doc_pages_on_doc_id", using: :btree
  add_index "survey_link_doc_pages", ["page_id"], name: "index_survey_link_doc_pages_on_page_id", using: :btree

  create_table "survey_link_doc_version_pages", force: true do |t|
    t.integer  "doc_version_id"
    t.integer  "page_id"
    t.integer  "page_version_id"
    t.integer  "page_order"
    t.boolean  "page_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_link_doc_version_pages", ["doc_version_id"], name: "index_survey_link_doc_version_pages_on_doc_version_id", using: :btree
  add_index "survey_link_doc_version_pages", ["page_id"], name: "index_survey_link_doc_version_pages_on_page_id", using: :btree
  add_index "survey_link_doc_version_pages", ["page_version_id"], name: "index_survey_link_doc_version_pages_on_page_version_id", using: :btree

  create_table "survey_link_doc_versions", force: true do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.integer  "doc_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_link_doc_versions", ["doc_id"], name: "index_survey_link_doc_versions_on_doc_id", using: :btree

  create_table "survey_link_docs", force: true do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.integer  "order_index"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_link_group_relationships", force: true do |t|
    t.integer  "group_id"
    t.integer  "child_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_link_group_relationships", ["child_id"], name: "index_survey_link_group_relationships_on_child_id", using: :btree
  add_index "survey_link_group_relationships", ["group_id"], name: "index_survey_link_group_relationships_on_group_id", using: :btree

  create_table "survey_link_groups", force: true do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_link_messages", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_link_multiple_choices", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_link_numerics", force: true do |t|
    t.integer  "max_digits"
    t.integer  "correct_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_group_assignment"
    t.integer  "report_subject_id"
  end

  create_table "survey_link_open_endeds", force: true do |t|
    t.integer  "max_chars"
    t.integer  "max_seconds"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_link_options", force: true do |t|
    t.integer  "multiple_choice_id"
    t.integer  "input_value"
    t.integer  "jump_to_id"
    t.string   "jump_to_type"
    t.boolean  "is_correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "report_subject_id"
  end

  add_index "survey_link_options", ["group_id"], name: "index_survey_link_options_on_group_id", using: :btree
  add_index "survey_link_options", ["jump_to_id"], name: "index_survey_link_options_on_jump_to_id", using: :btree
  add_index "survey_link_options", ["multiple_choice_id"], name: "index_survey_link_options_on_multiple_choice_id", using: :btree

  create_table "survey_link_page_links", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_link_page_versions", force: true do |t|
    t.string   "name",         null: false
    t.string   "description"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "content_id"
    t.string   "content_type"
    t.integer  "jump_to_id"
    t.string   "jump_to_type"
  end

  add_index "survey_link_page_versions", ["content_id"], name: "index_survey_link_page_versions_on_content_id", using: :btree
  add_index "survey_link_page_versions", ["jump_to_id"], name: "index_survey_link_page_versions_on_jump_to_id", using: :btree
  add_index "survey_link_page_versions", ["page_id"], name: "index_survey_link_page_versions_on_page_id", using: :btree

  create_table "survey_link_pages", force: true do |t|
    t.string   "name",         null: false
    t.string   "description"
    t.integer  "order_index"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_link_id"
  end

  add_index "survey_link_pages", ["page_link_id"], name: "index_survey_link_pages_on_page_link_id", using: :btree

  create_table "survey_link_reporters", force: true do |t|
    t.string   "subject_class"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_link_statements", force: true do |t|
    t.string   "text"
    t.string   "audio_path"
    t.integer  "order_index"
    t.integer  "content_id"
    t.string   "content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "before_content_id"
    t.string   "before_content_type"
    t.integer  "after_content_id"
    t.string   "after_content_type"
  end

  add_index "survey_link_statements", ["after_content_id"], name: "index_survey_link_statements_on_after_content_id", using: :btree
  add_index "survey_link_statements", ["before_content_id"], name: "index_survey_link_statements_on_before_content_id", using: :btree
  add_index "survey_link_statements", ["content_id"], name: "index_survey_link_statements_on_content_id", using: :btree

  create_table "survey_link_tag_taggable_objects", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_object_id"
    t.string   "taggable_object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_link_tag_taggable_objects", ["tag_id"], name: "index_survey_link_tag_taggable_objects_on_tag_id", using: :btree
  add_index "survey_link_tag_taggable_objects", ["taggable_object_id"], name: "index_survey_link_tag_taggable_objects_on_taggable_object_id", using: :btree

  create_table "survey_link_tags", force: true do |t|
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",          null: false
    t.string   "description"
  end

end
