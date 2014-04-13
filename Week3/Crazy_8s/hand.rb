class WrongCardError < RuntimeError
  def initialize
    super("Cannot play that card. Must be same suit, same value, or an eight.")
  end
end

class Hand
  # takes the a `Deck` and creates and returns a `Hand`
  # object.
  def self.deal_from(deck)
    Hand.new(deck.take(8))
  end

  attr_accessor :cards

  def initialize(cards)
    @cards = cards
  end

  def points
    total_points = 0
    @cards.each { |card| total_points += card.crazy_value }
  end
  
  def draw(deck)
    @cards += deck.take(1)
  end

  def return_cards(deck)
    deck.discard(@cards)
    @cars = nil
  end
  
  def play_card(card, deck)
    raise WrongCardError unless valid_move?
    
    if card.value == :eight
      player.change_suit
    end
    
    deck.discard(card)
    @hand.delete(card)
  end
  
  def valid_move?(card)
    return false if @discard.empty?
    top_card = @discard.last
    
    card.match(top_card) || card.value == :eight
  end

  def to_s
    @cards.join(",") + " (#{points})"
  end
end