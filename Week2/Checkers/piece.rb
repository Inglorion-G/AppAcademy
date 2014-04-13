require 'colorize'

class InvalidMoveError < RuntimeError
  def initialize
    super("Can't make that move!")
  end
end

class NoJumpError < InvalidMoveError
  def initialize
    super("There is no piece to jump here.")
  end
end

class Piece
  
  RED_MOVE_DELTAS = [ [1, 1], [-1, 1] ]
  RED_JUMP_DELTAS = [ [2, 2], [-2, 2] ]
  BLACK_MOVE_DELTAS = [ [1, -1], [-1, -1] ]
  BLACK_JUMP_DELTAS = [ [2, -2], [-2, -2] ]
  
  KING = "\u265B"
  PIECE = "\u2B24"
  
  attr_reader :color, :symbol
  attr_accessor :position
  
  def initialize(color, board, position, king=false)
    @color = color
    @board = board
    @position = position
    @king = king
    @symbol = PIECE
  end
  
  def king?
    @king
  end
  
  def perform_jump(new_pos)
    x, y = @position
    x2, y2 = new_pos
    jump = jump_square(new_pos)
    
    return false unless can_jump?(new_pos)
    @board.remove_piece(jump)
    @position = new_pos
    @board.grid[y][x], @board.grid[y2][x2] = @board.grid[y2][x2], @board.grid[y][x]
    promote if promote?
    true
  end
  
  def perform_slide(new_pos)
    x, y = @position
    x2, y2 = new_pos
    
    return false unless can_slide?(new_pos)
    @position = new_pos
    @board.grid[y][x], @board.grid[y2][x2] = @board.grid[y2][x2], @board.grid[y][x]
    promote if promote?
    true
  end
  
  def perform_moves(moves)
    if valid_move_seq?(moves)
      perform_moves!(moves)
    else
      raise InvalidMoveError
    end
  end
  
  def perform_moves!(moves)
    if moves.length < 2
      unless perform_slide(moves.first) || perform_jump(moves.first)
        raise InvalidMoveError
      end
    else
      moves.each do |move|
        attempt = perform_jump(move)
        raise InvalidMoveError unless attempt
      end
    end
  end
  
  def valid_move_seq?(sequence)
    x, y = @position
    test_board = @board.dup_board
    begin 
      test_board.get([x, y]).perform_moves!(sequence)
    rescue InvalidMoveError
      return false
    end
    true
  end
  
  private
  
  def promote?
    color == :red ? @position[1] == 7 : @position[1] == 0
  end
  
  def promote
    @king = true
    @symbol = KING
  end
  
  def jump_square(new_pos)
    x, y = @position
    x2, y2 = new_pos
    [((x + x2) / 2), ((y + y2) / 2)]
  end
  
  def within_border?(new_pos)
    x, y = new_pos
    x.between?(0, 7) && y.between?(0, 7)
  end
  
  def can_slide?(new_pos)
    x, y = @position
    x2, y2 = new_pos
    delta = [x2 - x, y2 - y]
    
    if @king
      return false unless (RED_MOVE_DELTAS + BLACK_MOVE_DELTAS).include?(delta)
    elsif self.color == :red
      return false unless RED_MOVE_DELTAS.include?(delta)
    else
      return false unless BLACK_MOVE_DELTAS.include?(delta)
    end
    
    within_border?(new_pos) && square_empty?(new_pos)
  end
  
  def can_jump?(target_pos)
    x, y = @position
    x2, y2 = target_pos
    delta = [x2 - x, y2 - y]
    jump = jump_square(target_pos)
    
    if @king
      return false unless (RED_JUMP_DELTAS + BLACK_JUMP_DELTAS).include?(delta)
    elsif self.color == :red
      return false unless RED_JUMP_DELTAS.include?(delta)
    else
      return false unless BLACK_JUMP_DELTAS.include?(delta)
    end
    
    return false unless square_has_enemy?(jump)
    within_border?(target_pos) && square_empty?(target_pos)
  end
  
  def square_empty?(square)
    x, y = square
    @board.grid[y][x].nil?
  end
  
  def square_has_enemy?(square)
    x, y = square
    return false if @board.grid[y][x] == nil
    @board.grid[y][x].color != self.color
  end
  
end