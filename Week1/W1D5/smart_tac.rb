require '/Users/GeorgeGroh/Desktop/ned_toe.rb'

class TicTacToeNode

  attr_accessor :board, :current_mark, :prev_move_pos

  MARKS = {:o => :x , :x => :o }

  def initialize(board, current_mark, prev_move_pos = nil)

    @board = board
    @current_mark = current_mark
    @prev_move_pos = prev_move_pos

  end

  def children
    moves = []

    self.board.rows.each_with_index do |row, ridx|
      row.each_with_index do |col, cidx|
        if col.nil?
          new_board = self.board.dup
          new_board[[ridx,cidx]] = self.current_mark
          moves << TicTacToeNode.new(new_board, MARKS[self.current_mark], [ridx,cidx])
        end
      end
    end

    moves
  end

  def losing_node?(mark)
    return true if board.winner == MARKS[mark]
    return false if board.rows.all? {|row| row.all? {|el| el.nil?}}
    return false if board.winner == mark
    return false if board.tied?
    child_states = []
    children.each do |child|
      child_states << child.losing_node?(mark)
    end

    # player turn and all child nodes are losers

    if self.current_mark == mark
      return child_states.all?
    end

    # oppenents turn and at least one child node is loser

    #if self.board[self.prev_move_pos] == mark
    return child_states.any?
      #end
    #false
  end

  def winning_node?(mark)
    return true if board.winner == mark
    return false if board.winner == MARKS[mark]
    return true if board.rows.all? {|row| row.all? {|el| el.nil?}}
    return false if board.tied?
    child_states = []
    children.each do |child|
      child_states << child.winning_node?(mark)
    end

    # player turn and all child nodes are losers

    if self.current_mark == mark
      return child_states.any?
    end

    # oppenents turn and at least one child node is loser

    #if self.board[self.prev_move_pos] == MARKS[mark]
    return child_states.all?
    #end
    #false
  end

end

# test_board = Board.new
# test_board[[0,0]] = :x
# # test_board[[0,0]] = :x
# # test_board[[0,2]] = :x
# # test_board[[2,0]] = :x
#
# p test_board.rows.each { |row| p row }
#
# node1 = TicTacToeNode.new(test_board, :o, [0,0])
# p node1.winning_node?(:x)


class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    rows = game.board.rows
    rows.each { |row| p row }
    return [1,1] if rows.all? {|row| row.all? {|el| el.nil?}}

    # winner_move(game, mark) || random_move(game)
    curr_node = TicTacToeNode.new(game.board, mark)
    next_moves = curr_node.children

    next_moves.each do |move|
      return move.prev_move_pos if move.winning_node?(mark)
    end

    next_moves.each do |move|
      return move.prev_move_pos unless move.losing_node?(mark)
      #next_moves.delete(move) if move.losing_node?(mark)
    end


    next_moves.sample.prev_move_pos
  end
end

#TicTacToe.new(SuperComputerPlayer.new,HumanPlayer.new("Newb")).run
TicTacToe.new(SuperComputerPlayer.new, SuperComputerPlayer.new).run