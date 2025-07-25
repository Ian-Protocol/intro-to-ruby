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

keywords_data.each do |keyword_name|
  Keyword.find_or_create_by!(keyword: keyword_name.downcase)
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
  CardType.find_or_create_by!(card_type: card_type_name.downcase)
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
funny_sets = %w[UGL UNH UST UNF UND PLIST PCEL AFR MB1 MB2]

# How AtomicCards is set up:
# card_name is key of top-level hash, and card_info is the full hash of data for that card.
cards_data.each do |card_name, card_info|
  # Skip if already created.
  next if Card.exists?(card_name: card_name.downcase)

  # Some cards contain multiple printings, stored in an array.
  card_info = card_info.first if card_info.is_a?(Array)

  # Skip if the card is funny.
  next if (Array(card_info["printings"]) & funny_sets).any?
  next if card_info["isFunny"]

  card = Card.create!(
    card_name: card_name.downcase,
    mana_cost: card_info["manaCost"].to_s,
    description: card_info["text"].to_s
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
    keyword = Keyword.find_by(keyword: keyword_name.downcase)

    if keyword
      CardsKeyword.find_or_create_by!(card: card, keyword: keyword)
    end
  end

  # Join to Types
  Array(card_info["types"]).each do |type_name|
    card_type = CardType.find_by(card_type: type_name.downcase)

    if card_type
      CardsCardType.find_or_create_by!(card: card, card_type: card_type)
    end
  end
end

# Wake up from nap (seeding takes 20 mins)
system('powershell.exe -c "(New-Object Media.SoundPlayer \\"C:\\\\Windows\\\\Media\\\\tada.wav\\").PlaySync();"')
system('powershell.exe -c "Add-Type -AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak(\'Your Rails seed is done. Get up, nerd.\');"')