
  def remove(node)
    if node.left.nil? && node.right.nil?
      #when node does not have children remove it
      node = nil
    elsif node.left && node.right.nil?
      #when node only has one child,
      #delete it and promote its child to take its place
      node = node.left
    elsif node.left.nil? && node.right
      node = node.right
    else
      node = replace_parent(node)
    end
    node

  end

  def delete_from_tree(node)
    node = remove(node)

  end

  def replace_parent(node)
    p node
    replacement_node = maximum(node.left)

    if replacement_node.left
      promote_child(node.left)
    end

    replacement_node.left = node.left
    replacement_node.right = node.right

    replacement_node

  end

  def maximum(tree_node = @root)
    if tree_node.right
      maximum_node = maximum(tree_node.right)
    else
      maximum_node = tree_node
    end

    maximum_node

  end

  def promote_child(tree_node)
    if tree_node.right
      maximum_node = maximum(tree_node.right)
    else
      return tree_node
    end

    tree_node.right = maximum_node.left

  end

  def delete_from_tree(tree_node)
    if tree_node == self.root
      self.root = remove(tree_node)
    elsif tree_node.is_right
      tree_node.parent.right = remove(tree_node)
    elsif !tree_node.is_right
      tree_node.parent.left = remove(tree_node)
    end

    tree_node

  end
