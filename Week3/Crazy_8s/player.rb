class NoSuitError < RuntimeError
  def initialize
    super("Must pick a valid suit.")
  end
end

class Player
  attr_reader :name
  attr_accessor :hand

  def initialize(name, deck)
    @name = name
    @hand = nil
  end
  
  def new_hand(deck)
    @hand = Hand.deal_from(deck)
  end
  
  def pick_suit
    puts "Pick a new suit to change to."
    suit = gets.chomp.to_sym
    raise NoSuitError unless [:hearts, :clubs, :diamonds, :spades].include?(suit)
    suit
  end
  
  def change_suit
    begin
      pick_suit
    rescue NoSuitError => e
      puts "#{e}"
      retry
    end
  end
  
end