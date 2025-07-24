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

# Idempotency
CardsColor.destroy_all
CardsKeyword.destroy_all
CardsCardType.destroy_all

Color.destroy_all
Keyword.destroy_all
CardType.destroy_all
Card.destroy_all

# Reset PK sequences
%w[
  cards
  colors
  keywords
  card_types
  cards_colors
  cards_keywords
  cards_card_types
].each do |table|
  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end

# Seed the colors
colors = ["W", "U", "B", "R", "G", "C"]

colors.each do |color|
  Color.find_or_create_by!(color: color)
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

# Seed the card types
cardtypes_file = Rails.root.join("db", "data", "CardTypes.json")

unless cardtypes_file.exist?
  puts "Did you forget to download the CardTypes JSON?"
  puts "Put it in /db/data/ please!"
  exit
end

cardtypes_json = JSON.parse(File.read(cardtypes_file))

cardtypes_json["data"].keys.each do |card_type_name|
  CardType.find_or_create_by!(card_type: card_type_name)
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

count = 0

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
  
  # Join to Colors
  # If card color doesn't exist, Array() returns [].
  Array(card_info["colors"]).each do |color_code|
    color = Color.find_by(color: color_code)
    if color
      # Rails extracts card.id and color.id
      CardsColor.find_or_create_by!(card: card, color: color)
    end
  end

  # Join to Keywords
  Array(card_info["keywords"]).each do |keyword_name|
    keyword = Keyword.find_by(keyword: keyword_name)

    if keyword
      CardsKeyword.find_or_create_by!(card: card, keyword: keyword)
    end
  end

  # Join to Types
  Array(card_info["types"]).each do |type_name|
    card_type = CardType.find_by(card_type: type_name)

    if card_type
      CardsCardType.find_or_create_by!(card: card, card_type: card_type)
    end
  end


  # Stop after 100
  count += 1

  if count > 100
    exit
  end
end