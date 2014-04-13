require_relative 'card'

# Represents a deck of playing cards.
class Deck
  
  attr_accessor :discard
  
  # Returns an array of all 52 playing cards.
  def self.all_cards
    52_pickup = []
    Card.suits.each do |suit|
      Card.values.each do |value|
        52_pickup << Card.new(suit, value)
      end
    end
    52_pickup
  end

  def initialize(cards = Deck.all_cards)
    @cards = cards
    @discard = []
  end

  # Returns the number of cards in the deck.
  
  def discard(card)
    @discard += card
  end
  
  def count
    @cards.count
  end

  # Takes `n` cards from the top of the deck.
  def take(n)
    @cards.unshift(n)
  end

  # Returns an array of cards to the bottom of the deck.
  def return
    @cards += @discard
    @discard.clear
    @cards.shuffle
  end
end