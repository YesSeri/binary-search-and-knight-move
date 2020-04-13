require 'pry'
require 'pry-byebug'
require_relative 'node'
# This class is used for manipulating and creating a binary search tree.
class Tree
  attr_reader :root

  def initialize(array)
    @root = prepare_build_tree(array)
  end

  def prepare_build_tree(array)
    array.sort!.uniq!
    root = build_tree(array)
    root
  end

  def build_tree(array)
    start = 0
    last = array.size - 1
    mid = array.size / 2
    root = Node.new(array[mid])
    return root if array.size == 1
    return nil if array.size == 0

    root.left = build_tree(array[start..mid - 1])
    root.right = build_tree(array[mid + 1..last])
    root
  end

  def find(value)
    level_order do |n|
      return n if n.data == value
    end
  end

  def rebalance!
    array = []
    inorder_traversal { |n| array << n.data }
    @root = prepare_build_tree(array)
  end

  def balanced_tree?(node = @root)
    a = count_tree(node.left)
    b = count_tree(node.right)
    (-1..1) === (a - b)
  end

  def count_tree(node)
    a = 0
    level_order(node) { a += 1 }
    a
  end
  
  def delete(value) #First if leaf, then if one child, last if two children. Two => recursion
    node = find(value)
    parent = find_parent(node)
    if node.left.nil? && node.right.nil?
      delete_leaf(node, parent)
    elsif node.left.nil?
      delete_node_one_child(node, node.right, parent)
    elsif node.right.nil?
      delete_node_one_child(node, node.left, parent)
    else # Both left and right exist. Use recursion.
      replace_node = inorder_traversal(node.right) { |n| break n } #Finds node to replace with
      delete(replace_node.data) #Enter recursion for found node, which needs to be deleted first.
      node.data = replace_node.data
    end
  end

  def delete_leaf(node, parent)
      if node.data < parent.data
        parent.left = nil
      else
        parent.right = nil
      end
  end

  def delete_node_one_child(node, child, parent)
    if node.data < parent.data
        parent.left = child
      else
        parent.right = child
      end
  end

  def level(node)
    level = 0
    while node != @root
      level += 1
      node = find_parent(node)
    end
    level
  end

  def find_parent(node)
    level_order do |n|
      if n.left == node || n.right == node
        return n
      end
    end
  end

  def insert(value)
    new_node = Node.new(value)
    root = @root
    loop do
      if value < root.data
        if root.left.nil?
          root.left = new_node
          break
        else
          root = root.left
        end
      elsif root.right.nil?
        root.right = new_node
        break
      else
        root = root.right
      end
    end
  end

  def level_order(node = @root, &block)
     
    queue = [node]
    array = []
    until queue.size == 0 
      temp = queue.shift
      yield temp if block_given?
      array << temp.data
      queue << temp.left if temp.left != nil
      queue << temp.right if temp.right != nil
    end
    return array if !block_given?
  end
  def inorder_traversal(root = @root, array = [], &block)
    return nil if root.nil?

    inorder_traversal(root.left, array, &block)
    if block_given?
      yield root
    else
      array << root.data
    end
    inorder_traversal(root.right, array, &block)
    array
  end

  def preorder_traversal(root = @root, array = [], &block)
    return nil if root.nil?

    if block_given?
      yield root
    else
      array << root.data
    end
    preorder_traversal(root.left, array, &block)
    preorder_traversal(root.right, array, &block)
    array
  end

  def postorder_traversal(root = @root, array = [], &block)
    return nil if root.nil?

    postorder_traversal(root.left, array, &block)
    postorder_traversal(root.right, array, &block)
    if block_given?
      yield root
    else
      array << root.data
    end
  end

  def last_node(node = @root)
    node = nil
    level_order{ |n| node = n }
    node
  end
  
  def to_s
    prev_n, prev_l, string, array = nil, nil, '', []
    level_order do |n|
      l = level(n)
      if prev_l != l
        array << string
        string = ''
      end
      if level(n) == level(prev_n) && find_parent(n) == find_parent(prev_n)
        string += '-'
      else
        string += ' '
      end
      string += n.data.to_s
      array << string if n == last_node
      prev_n, prev_l = n, l
    end
    array.each { |a| puts a.center(50) }
  end
  def print_all_order
    print level_order
    puts
    print preorder_traversal
    puts
    print inorder_traversal
    puts
    print postorder_traversal
    puts
  end
  # Copied from Run After's binary search program
  def pretty_print(node = root, prefix="", is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? "│   " : "    "}", false) if node.right
    puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.data.to_s}"
    pretty_print(node.left, "#{prefix}#{is_left ? "    " : "│   "}", true) if node.left
  end
end
array = Array.new(15) { rand(1..100) }
print array
tree = Tree.new(array)
puts "\nBalanced? #{tree.balanced_tree?}"
tree.pretty_print
tree.print_all_order
array = Array.new(10) { rand(200..300)}
array.each { |el| tree.insert(el) }
tree.pretty_print
puts "\nBalanced? #{tree.balanced_tree?}"
tree.rebalance!
tree.pretty_print
puts "\nBalanced? #{tree.balanced_tree?}"
