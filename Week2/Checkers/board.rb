require 'colorize'
require_relative 'piece.rb'

class NoPieceSelectedError < RuntimeError
  def initialize
    super("No piece selected.")
  end
end

class NoMoveError < RuntimeError
  def initialize
    super("No moves selected.")
  end
end

class WrongTurnError < RuntimeError
  def initialize
    super("Can't move other player's pieces.")
  end
end

class Board
  
  attr_accessor :grid, :cursor
  
  X_AXIS_LABEL = "   0  1  2  3  4  5  6  7  "
  CURSOR = ["> <".blink.blue.on_cyan, " \u2B24 ".blink.blue.on_cyan]
  
  def initialize(game, load = true)
    @grid = Array.new(8) { Array.new(8) }
    @game = game
    @cursor = [0, 0]
    load_board if load
  end
  
  def move_piece(sequence)
    move_sequence = sequence
    raise NoMoveError if sequence.empty?
    
    piece = get(move_sequence.slice!(0))
    raise NoPieceSelectedError if piece == nil
    raise WrongTurnError if piece.color != @game.turn
    piece.perform_moves(move_sequence)
  end
  
  def remove_piece(coordinate)
    set(coordinate, nil)
  end
  
  def dup_board
    dup_board = Board.new(false)
    
    @grid.each_with_index do |row, r_idx|
      row.each_with_index do |tile, t_idx|
        if tile.nil?
          dup_board.set([t_idx, r_idx], nil)
          # duplicate_board.set([t_idx, r_idx], nil)
        else
          dup_board.set([t_idx, r_idx], 
          tile.class.new(tile.color, dup_board, [t_idx, r_idx]))
        end
      end
    end
    dup_board
  end
  
  def render
    @grid.reverse_each.with_index do |row, y_axis|
      print "\n"
      print "#{(y_axis-7).abs} ".light_white

      row.each_with_index do |tile, x_axis|
        colorize(tile, x_axis, y_axis)
      end
    end

    print "\n"
    print X_AXIS_LABEL.light_white
  end
  
  def get(coordinate)
    x, y = coordinate
    @grid[y][x]
  end
  
  def set(coordinate, object)
    x, y = coordinate
    @grid[y][x] = object
  end
  
  private
  
  def colorize(tile, x_axis, y_axis)
    if (y_axis.even? && x_axis.odd?) || (y_axis.odd? && x_axis.even?)

      if ([x_axis, y_axis] == @cursor)
        if tile.nil?
          print CURSOR[0]
        else
          print CURSOR[1]
        end
      elsif tile.nil?
        print "   ".on_light_black
      elsif tile.color == :black
        print " #{tile.symbol} ".black.on_light_black
      else
        print " #{tile.symbol} ".light_red.on_light_black
      end
    else
      if ([x_axis, y_axis] == @cursor)
        if tile.nil?
          print CURSOR[0]
        else
          print CURSOR[1]
        end
      elsif tile.nil?
        print "   ".on_white
      elsif tile.color == :black
        print " #{tile.symbol} ".black.on_white
      else
        print " #{tile.symbol} ".light_red.on_white
      end
    end
  end
  
  def load_board
    @grid.reverse_each.with_index do |row, y|
      row.each_with_index do |tile, x|
        if dark_square?(x, y) && y.between?(0, 2)
          set([x, y], Piece.new(:red, self, [x, y]))
        elsif
          dark_square?(x, y) && y.between?(5, 7)
          set([x, y], Piece.new(:black, self, [x, y]))
        end
      end
    end
  end
  
  def dark_square?(x, y)
    (x.even? && y.even?) || (x.odd? && y.odd?)
  end   
  
end