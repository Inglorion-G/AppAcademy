class Game
  
  def initialize(deck)
    @deck = deck
    @player1 = Player.new("Ricky", @deck)
    @player2 = Player.new("Bobby", @deck)
    @turn = :player_1
  end
  
  def begin_game
    players = [@player1, @player2]
    players.each { |player| player.new_hand(@deck) }
    
    @deck.discard(@deck.take(1))
  end
  
  def play_turn
    puts "Top card is... " @deck.top_card
    @turn == :player1 ? @turn = :player2 : @turn = :player1
  end
  
end