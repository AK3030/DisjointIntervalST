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
      return [nil, false]
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

    elsif node.left
      p "hi - - -"
      node.left.parent = node.parent
      if node.is_right
        node.parent.right = node.left
      elsif !node.is_right
        node.parent.left = node.left
      end
      node
    elsif node.right
      node.right.parent = node.parent
      if node.is_right
        node.parent.right = node.right
      elsif !node.is_right
        node.parent.left = node.right
      end
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

  def find_intersection_minmax(new_node)
    del_nodes = []
    intersection = find_intersection(root, new_node)
    max = nil
    min = nil

    while intersection[1]
      p intersection
      # cant use reference to node here because nodes mutate during deletion
      del_nodes << [intersection[0].s, intersection[0].e]
      max = intersection[0].e if max.nil? || intersection[0].e > max
      min = intersection[0].s if min.nil? || intersection[0].s < min

      # p del_nodes
      remove(intersection[0])
      intersection = find_intersection(root, new_node)

    end
    p del_nodes
    [min, max]
  end

  def merge(new_node)
    int_minmax = find_intersection_minmax(new_node)
    upper = [int_minmax[1], new_node.e].max
    lower = [int_minmax[0], new_node.s].min

    p int_minmax
    p [new_node.s, new_node.e]
    merge_node = ISTNode.new(lower, upper)
    insert(merge_node)

  end

end

a = IntervalSearchTree.new
some_node = ISTNode.new(4,6)
root = ISTNode.new(1,3)
other_node = ISTNode.new(20,25)
the_node = ISTNode.new(15,17)
another_node = ISTNode.new(6,12)
two_node = ISTNode.new(30,40)
arr = [root,
two_node,
some_node,
the_node,
other_node,
another_node
]


arr.each do |node|
  a.insert(node)
end
# p a.in_order_traversal

# all = a.find_intersection_minmax(two_node)
# p a.find_intersection(two_node)
# p a.in_order_traversal
# p two_node.right
# p two_node.left
# p two_node.parent
# p two_node.parent.right
# a.remove(two_node)
# p a.in_order_traversal
# p a.in_order_traversal
merging_node = ISTNode.new(16,22)
a.merge(merging_node)
p a.in_order_traversal


# p a.intersects(two_node, other_node)
# p all
# p a.find_intersection(two_node)
# all.each do |range|
#   p range
# end



# p a.find_intersection(a.root, another_node)
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
