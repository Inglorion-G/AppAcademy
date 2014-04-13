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
    if self.children.size == 2
      raise "Already has two children."
    end

    if child_node.parent
      child_node.parent.children.delete(child_node)
    end

    child_node.parent = self
    self.children << child_node
  end

  def dfs(value)
    p self.value
    temp = nil
    return self if self.value == value
    return nil if self.children.empty?
    temp = self.children[0].dfs(value)
    temp = self.children[1].dfs(value) if temp.nil? && self.children.size > 1
    temp
  end

  def bfs(value)
    q = [self]
    until q.empty?
      current_node = q.shift
      p current_node.value
      return current_node if current_node.value == value

      q.concat(current_node.children)
    end
  end

end



# node_1 = TreeNode.new(10)
# node_2 = TreeNode.new(9)
# node_3 = TreeNode.new(11)
# node_4 = TreeNode.new(8)
# node_5 = TreeNode.new(7)
# node_6 = TreeNode.new(4)
#
# node_1.add_child(node_2)
# node_1.add_child(node_3)
# node_2.add_child(node_4)
# node_2.add_child(node_5)
# node_4.add_child(node_6)
#
# node_1.bfs(7)