# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_12_12_224603) do
  create_table "games", force: :cascade do |t|
    t.string "game_id"
    t.integer "winning_player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "master_decks", force: :cascade do |t|
    t.string "cardName"
    t.integer "cardPower"
    t.integer "cardDefense"
    t.string "cardDescription"
    t.integer "cardCost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_decks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_games", force: :cascade do |t|
    t.integer "user_id"
    t.integer "opponent_id"
    t.integer "game_id"
    t.boolean "isActive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gamesPlayed"
    t.integer "gamesWon"
    t.integer "gamesLost"
  end

end