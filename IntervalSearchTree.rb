require_relative "ISTNode"

class IntervalSearchTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  def insert(new_node)
    @root = insert_into_tree(@root, new_node)
  end

  def insert_into_tree(curr_node, new_node)

    if curr_node && (curr_node.largest < new_node.e)
      curr_node.largest = new_node.e
    end

    return new_node if curr_node.nil?

    new_node.parent = curr_node

    if new_node.s <= curr_node.s
      new_node.is_right = false
      curr_node.left = insert_into_tree(curr_node.left, new_node)
    elsif new_node.s > curr_node.s
      new_node.is_right = true
      curr_node.right = insert_into_tree(curr_node.right, new_node)
    end

    curr_node
  end

  def in_order_traversal(tree_node = @root, arr = [])

    if tree_node.left
      in_order_traversal(tree_node.left, arr)
    end

    arr.push([tree_node.s, tree_node.e])

    if tree_node.right
      in_order_traversal(tree_node.right, arr)
    end

    arr

  end

  def minimum(tree_node)
    minimum_node = tree_node
    if tree_node.left
      minimum_node = tree_node.left
    else
      minimum_node
    end

  end


  def intersects(curr_node, new_node)
    # p curr_node.s
    # p curr_node.e
    # p curr_node.largest
    #
    # p new_node.s
    # p new_node.e
    if (new_node.s <= curr_node.s) && (new_node.e >= curr_node.e)
      return :surrounds
    elsif (new_node.s >= curr_node.s) && (new_node.e <= curr_node.e)
      return :full_inside
    elsif (new_node.s >= curr_node.s) && (new_node.s <= curr_node.e)
      return :left_inside
    elsif (new_node.e <= curr_node.e) && (new_node.e >= curr_node.s)
      return :right_inside
    else
      return false
    end
  end

  def find_intersection(tree_node = @root, new_node)
    # p tree_node.s
    # p tree_node.e
    # p tree_node.largest
    # p " "
    if tree_node.nil?
      return :none
    elsif intersects(tree_node, new_node)

      return [tree_node, intersects(tree_node, new_node)]
    elsif tree_node.left.nil?

      find_intersection(tree_node.right, new_node)
    elsif tree_node.left.largest < new_node.s

      find_intersection(tree_node.right, new_node)
    else

      find_intersection(tree_node.left, new_node)
    end
  end

  def remove(node)
    # p node
    if node.left && node.right
      swap_node = minimum(node.right)
      # swap_val = [swap_node.s, swap_node.e]
      remove(swap_node)
      node.s = swap_node.s
      node.e = swap_node.e


      # swap_node = minimum(node.right)
      # # p " - - - "
      # p swap_node
      # # remove(swap_node)
      # # p swap_node
      # #
      # # p self.root
      # if node == self.root
      #
      #   self.root = swap_node
      # else
      #   if node.is_right
      #     node.parent.right = swap_node
      #   else
      #     node.parent.left = swap_node
      #   end
      # end
      # node
    elsif node.left
      node.left.parent = node.parent
      node.paren.left = node.left
      node
    elsif node.right
      node.right.parent = node.parent
      node.parent.right = node.right
      node
    else
      if node.is_right
        node.parent.right = nil
      else
        node.parent.left = nil
      end
    end
    false

  end

end

a = IntervalSearchTree.new
some_node = ISTNode.new(1,6)
root = ISTNode.new(1,3)
other_node = ISTNode.new(4,9)
the_node = ISTNode.new(5,9)
another_node = ISTNode.new(1.5,5)
two_node = ISTNode.new(2,3)
arr = [root,
two_node,
some_node,
the_node,
other_node,
another_node
]

a_node = ISTNode.new(6,7)
arr.each do |node|
  a.insert(node)
end





# p a.find_intersection(a.root, a_node)
# a.delete_from_tree(root)
# p a.root.left
# p a.in_order_traversal
# p some_node
# a.remove(root)
# a.remove(some_node)
# a.remove(other_node)
# a.insert(other_node)
# p a.in_order_traversal
# p a.root.left = nil

# p a.minimum(a.root)



# p a.in_order_traversal
# p a
