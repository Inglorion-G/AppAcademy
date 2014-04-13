class KnightPathFinder

  MOVE_POSITIONS = [
    [+1,+2],
    [-1,-2],
    [+1,-2],
    [-1,+2],
    [+2,+1],
    [+2,-1],
    [-2,+1],
    [-2,-1]
  ]

  attr_accessor :start_pos, :tree

  def initialize(start_pos)
    @start_pos = start_pos
    @tree = create_node(self.start_pos)
    build_move_tree
  end

  def create_node(value)
    new_node = TreeNode.new(value)
  end

  def build_move_tree
    q = [self.tree]
    coordinates = []
    until q.empty?
      current_node = q.shift
      coordinates << current_node.value

      self.class.new_move_positions(current_node.value).each do |pos|
        child = create_node(pos)
        unless coordinates.include?(pos)
          current_node.add_child(child)
          q << child
        end
      end
    end
    self.tree.value
  end

  def self.new_move_positions(pos)
    x,y = pos
    moves = []
    MOVE_POSITIONS.each do |position|
      moves << [x + position[0], y + position[1]]
    end

    moves.select{ |move| (0..7).include?(move[0]) && (0..7).include?(move[1]) }
  end

  def find_path(target)
    search_node = self.tree.dfs(target)
    search_node.path
  end

end

#p KnightPathFinder.new([1,2]).build_move_tree

##########################################################


class TreeNode
  attr_accessor :parent, :children, :value

  def initialize(value)
    @parent = nil
    @children = []
    @value = value
  end

  def remove_child(child_node)
    if self.children.include?(child_node)
      child_node.parent = nil
      self.children.delete(child_node)
    else
      nil
    end
  end

  def add_child(child_node)
    if self.children.size == 8
      raise "Already has eight children."
    end

    if child_node.parent
      child_node.parent.children.delete(child_node)
    end

    child_node.parent = self
    self.children << child_node
  end

  def bfs(value)
    q = [self]
    explored_tiles = []
    until q.empty?
      current_node = q.shift
      explored_tiles << current_node
      p current_node.value
      return current_node if current_node.value == value
      current_node.children.each do |child|
        q << child if !explored_tiles.include?(child) && !q.include?(child)
      end
    end
  end

  def dfs(value)
    temp = nil
    return self if self.value == value
    return nil if self.children.empty?
    self.children.each do |child|
      temp = child.dfs(value)
      return temp if !temp.nil?
    end
    nil
  end

  def path
    if parent
      parents = self.parent.path
      return parents += [self.value]
    end
    [self.value]
  end

end

p KnightPathFinder.new([0,0]).find_path([3,7])