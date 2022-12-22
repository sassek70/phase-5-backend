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

ActiveRecord::Schema[7.0].define(version: 2022_12_22_145310) do
  create_table "cards", force: :cascade do |t|
    t.string "cardName"
    t.integer "cardPower"
    t.integer "cardDefense"
    t.string "cardDescription"
    t.integer "cardCost"
    t.string "artist"
    t.string "image"
    t.integer "mtgo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer "host_user_id"
    t.integer "opponent_id"
    t.string "game_key"
    t.integer "winning_player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "host_player_health", default: 15
    t.integer "opponent_player_health", default: 15
  end

  create_table "player_action_cards", force: :cascade do |t|
    t.integer "user_card_id"
    t.integer "player_action_id"
    t.boolean "is_attacking"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_actions", force: :cascade do |t|
    t.integer "game_id"
    t.integer "winning_card_id"
    t.integer "destroyed_card_id"
    t.boolean "both_destroyed", default: false
    t.boolean "draw", default: false
    t.boolean "unblocked_attack", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_cards", force: :cascade do |t|
    t.integer "user_id"
    t.integer "card_id"
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
