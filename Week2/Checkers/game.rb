require_relative 'board.rb'
require 'yaml'
require 'ostruct'

class Checkers
  
  attr_reader :cursor_x, :cursor_y, :turn
  
  SAVE_FILE = 'checkers.yaml'
  
  def initialize
    @board = Board.new(self)
    @turn = :red
    @quit = false
  end
  
  def play
    until game_over || @quit do
      play_turn
      rotate_turn
    end  
  end
  
  def play_turn
    begin
      system("clear")
      display
      moves = get_move_sequence
      @board.move_piece(moves)
    rescue NoMoveError
      retry
    rescue InvalidMoveError
      retry
    rescue NoPieceSelectedError
      retry
    rescue WrongTurnError
      retry
    end
  end
  
  def rotate_turn
    @turn == :red ? @turn = :black : @turn = :red
  end
  
  def game_over
    if game_over?
      if @board.grid.flatten.compact.all? { |piece| piece.color == :red }
        puts "Congratulations, Red, you win!"
      else
        puts "Congratulations, Black, you win!"
      end
      return true
    end
    false
  end
  
  def game_over?
    test_board = @board.grid.flatten.compact
    test_board.all? { |piece| piece.color == test_board[0].color }
  end
  
  # Thanks to http://stackoverflow.com/questions/8142901/ruby-stdin-getc-does-not-read-char-on-reception
  
  def get_char
    begin
      system("stty raw -echo")
      str = STDIN.getc
    ensure
      system("stty -raw echo")
    end
    str.chr
  end
  
  # get_move_sequence based on work from jeffnv
  # https://github.com/jeffnv/aa_work/blob/master/w2/w2d4/checkers.rb
  
  def get_move_sequence
    #system("clear")
    sequence = []
    command = get_char
    
    while true
      display
      system("clear")
      display
      input = get_char
      cursor_x = @board.cursor[0]
      cursor_y = @board.cursor[1]
      
      case input
      when 'w'
        cursor_y -= 1 unless cursor_y <= 0
      when 'd'
        cursor_x += 1 unless cursor_x >= 7
      when 's'
        cursor_y += 1 unless cursor_y >= 7
      when 'a'
        cursor_x -= 1 unless cursor_x <= 0
      when 'k'
        exit
      when 'p'
        puts sequence
      when ' ' 
        sequence << ([cursor_x, (cursor_y - 7).abs])
      when "m"
        return sequence
      end
      
      @board.cursor = [cursor_x, cursor_y]
      #system("clear")
    end
  end
  
  def display
    puts "#{@turn.capitalize} Player's Turn"
    @board.render
  end
  
  def begin_game
    system("clear")
    puts "Welcome to checkers!"
    puts "Instructions:"
    print "\n"
    puts "Move the cursor with the 'W', 'A', 'S', and 'D' keys."
    puts "Select your piece by pressing SPACEBAR, and then press SPACEBAR again"
    puts "on the tile you want to move or jump to. Then press 'M' to make the move."
    puts "Press 'K' to quit while in the game."
    puts "Enjoy!"
    print "\n"
    puts "Type 'play' to start a game, or anything else to exit."
    player_input = gets.chomp
    player_input
    
    if player_input == 'play'
      play
    else
      puts "Ok, bye!"
    end     
  end
  
end

Checkers.new.begin_game