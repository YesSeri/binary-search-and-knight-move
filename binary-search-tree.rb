require 'pry' 
require 'pry-byebug'
class Node
  attr_accessor :data, :left, :right
  include Comparable
  
  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
  
  def <=>(other_node)
    if other_node.nil?
      return -1
    else
      @data <=> other_node.data
    end
  end
end
class Tree
  attr_reader :root
  
  def initialize(array)
    @root = prepare_build_tree(array)
  end
  
  def prepare_build_tree(array)
    array.sort!.uniq!
    puts "#{array}"
    root = build_tree(array)
    return root
  end
  
  def build_tree(array) #[1, 3, 4, 8, 9, 23, 55]
    start = 0
    last = array.size-1
    mid = array.size/2
    root = Node.new(array[mid])
    return root if array.size == 1
    return nil if array.size == 0
    
    root.left = build_tree(array[start..mid-1])
    root.right = build_tree(array[mid+1..last])
    root
  end
  
  def find(value)
    level_order do |n|
      return n if n.data == value
    end
  end
  
  def rebalance! (node=@root)
    array = []
    inorder_traversal {|n| array << n.data}
    @root = prepare_build_tree(array)
  end
  
  def balanced_tree?(node=@root)
    a = count_tree(node.left)
    b = count_tree(node.right)
    if (-1..1) === (a-b)
      true
    else
      false
    end
  end
  
  def count_tree(node)
    a = 0
    level_order([node]) {|n| a += 1}
    a
  end
  
  def delete(value)
    node= find(value)
    parent = find_parent(node)
    if node.left.nil? && node.right.nil?
      if node.data < parent.data
        parent.left = nil
      else
        parent.right = nil
      end
    elsif node.left.nil?
      if node.data < parent.data
        parent.left = node.right
      else
        parent.right = node.right
      end
    elsif node.right.nil?
      if node.data < parent.data 
        parent.left = node.left
      else
        parent.right = node.left
      end
    else #both left and right exist. Use recursion.
      replace_node = inorder_traversal(node.right) {|n| break n} #gives first inorder in right rubtree. 
      delete(replace_node.data)
      node.data = replace_node.data
    end
  end
  
  def find_next_inorder(node)
    inorder_traversal(node) {|n| return n}
  end
  
  def find_parent(node)
    level_order do |n|
      if n.left == node || n.right == node
        return n
      end
    end
  end
        #check if leaf.
  
  def insert(value)
    new_node = Node.new(value)
    root = @root
    while (true)
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

  def level_order(array = [@root], level = 0, &block)
    return nil if array.empty?

    next_array = []
    string = ''
    array.each do |root|
      if block_given?
        yield(root, level)
      else
        string += "#{root.data.to_s.ljust(5)} "
      end
      next_array << root.left if root.left
      next_array << root.right if root.right
    end
    unless block_given?
      puts string.center(111, ' ')
      puts
    end
    level += 1
    level_order(next_array, level, &block)
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

  def depth(node)
    level_order { |n, l| return l if n == node }
  end

  def last_node(node = @root)
    node = nil
    level_order{ |n| node = n }
    node
  end
  
  def to_s
    prev_n, prev_l, string, array = nil, nil, '', []
    level_order do |n, l|
      if prev_l != l
        array << string
        string = ''
      end
      if depth(n) == depth(prev_n) && find_parent(n) == find_parent(prev_n)
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
end
i = 1
array = []
15.times do
  array << i
  i += 1
end
tree = Tree.new(array)
tree.to_s
