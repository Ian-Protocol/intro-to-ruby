# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'json'

# Seed the colors
colors = ["W", "U", "B", "R", "G", "C"]

colors.each do |color|
  Color.find_or_create_by!(color: color)
end

# Seed the cards

# OS agnostic
cards_file = Rails.root.join("db", "data", "AtomicCards.json")

unless cards_file.exist?
  puts "Did you forget to download the AtomicCards JSON?"
  puts "Put it in /db/data/ please!"
  exit
end

cards_json = JSON.parse(File.read(cards_file))

cards_data = cards_json["data"]
card_count = 0

# How AtomicCards is set up:
# card_name is key of top-level hash, and card_info is the full hash of data for that card.
cards_data.each do |card_name, card_info|
  # Skip if already created.
  next if Card.exists?(name: card_name)

  card = Card.create!(
    name: card_name,
    mana_cost: card_info["manaCost"],
    description: card_info["text"]
  )
  card_count += 1

  # TEMPORARY! Stop after 100 until tested.
  break if card_count >= 100
end

# Seed the keywords
keywords_file = Rails.root.join("db", "data", "Keywords.json")

unless keywords_file.exist?
  puts "Did you forget to download the Keywords JSON?"
  puts "Put it in /db/data/ please!"
  exit
end

keywords_json = JSON.parse(File.read(keywords_file))
keywords_data = keywords_json["data"]["keywordAbilities"]

keyword_abilities.each do |keyword_name|
  Keyword.find_or_create_by!(keyword: keyword_name)
end