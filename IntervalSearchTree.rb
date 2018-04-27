require_relative "ISTNode"

class IntervalSearchTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  def insert(new_node)
    @root = insert_into_tree(@root, new_node)
  end

  # the interval search tree uses the start of the interval
  # as a key to arrange the tree

  def insert_into_tree(curr_node, new_node)
    # each node tracks the largest end of an interval in
    # its entire subtree
    if curr_node && (curr_node.largest < new_node.e)
      curr_node.largest = new_node.e
    end

    return new_node if curr_node.nil?

    new_node.parent = curr_node

    if new_node.s <= curr_node.s
      curr_node.left = insert_into_tree(curr_node.left, new_node)
    elsif new_node.s > curr_node.s
      curr_node.right = insert_into_tree(curr_node.right, new_node)
    end

    curr_node
  end

  def in_order_traversal(tree_node = @root, arr = [])
    return [] if @root == nil

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

# returns intersection types based on whether the new
# range totally surrounds the node, is completely inside
# or partially inside
  def intersects(curr_node, new_node)
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

    if tree_node.nil?
      return [nil, false]
    elsif intersects(tree_node, new_node)
      return [tree_node, intersects(tree_node, new_node)]
    elsif tree_node.left.nil?
      find_intersection(tree_node.right, new_node)
    elsif tree_node.left.largest < new_node.s
      # when searching the tree for intersections if the left substrees
      # greatest right bound is less than the new ranges left bound
      # there can not be any intersections to the left
      find_intersection(tree_node.right, new_node)
    else
      find_intersection(tree_node.left, new_node)
    end
  end

# remove method should be cleaned up by using seperate methods
# for different cases
  def remove(node)

    if node.left && node.right
      swap_node = minimum(node.right)
      remove(swap_node)
      node.s = swap_node.s
      node.e = swap_node.e
    elsif node.left
      if node.parent.nil?
        @root = node.left
        @root.parent = nil
      else
        node.left.parent = node.parent
        if node.is_right
          node.parent.right = node.left
        elsif !node.is_right
          node.parent.left = node.left
        end
        node
      end
    elsif node.right
      if node.parent.nil?
        @root = node.right
        @root.parent = nil
      else
        node.right.parent = node.parent
        if node.is_right
          node.parent.right = node.right
        elsif !node.is_right
          node.parent.left = node.right
        end
        node
      end
    else
      if node.parent.nil?
        @root = nil
      else
        if node.is_right
          node.parent.right = nil
        else
          node.parent.left = nil
        end
      end
    end
    false

  end

  def find_intersection_minmax(new_node)
    del_nodes = []
    intersection = find_intersection(root, new_node)
    max = nil
    min = nil
    i = 0
    while intersection[1] && i < 50
      i+=1
      # p intersection
      # cant use reference to node here because nodes mutate during deletion
      del_nodes << [intersection[0].s, intersection[0].e]
      max = intersection[0].e if max.nil? || intersection[0].e > max
      min = intersection[0].s if min.nil? || intersection[0].s < min
      remove(intersection[0])

      intersection = find_intersection(root, new_node)
    end
    [min, max]
  end

  def merge(new_node)
    int_minmax = find_intersection_minmax(new_node)

    if int_minmax[0] == nil && int_minmax[1] == nil

      insert(new_node)
      return
    end

    upper = [int_minmax[1], new_node.e].max
    lower = [int_minmax[0], new_node.s].min

    merge_node = ISTNode.new(lower, upper)
    insert(merge_node)
  end

  def delete_range(new_node)
    # new node is the range thats being deleted

    int_minmax = find_intersection_minmax(new_node)
    merge_nodes = []

    if int_minmax[0] >= new_node.s && int_minmax[1] <= new_node.s
      # do nothing because only full ranges have been deleted
      return
    elsif new_node.s > int_minmax[0] && new_node.e > int_minmax[1]
      # cuts off right side of one range and either
      # deletes all the rest or does nothing else
      merge_nodes << ISTNode.new(int_minmax[0], new_node.s)
    elsif new_node.s > int_minmax[0] && new_node.e < int_minmax[1]
      merge_nodes << ISTNode.new(int_minmax[0], new_node.s)
      merge_nodes << ISTNode.new(new_node.e, int_minmax[1])

    elsif new_node.s < int_minmax[0] && new_node.e < int_minmax[1]
      merge_nodes << ISTNode.new(new_node.e, int_minmax[1] )
    end
    # could have been more concise by reusing my intercept method and
    # using a node object instead of the minmax array

    merge_nodes.each do |node|
      insert(node)
    end

  end

end
