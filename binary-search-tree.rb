class Node
  attr_accessor :data, :left, :right
  include Comparable
  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
  def <=>(other_node)
    @data <=> other_node.data
  end
end
class Tree
  attr_reader :root
  def initialize(array)
    @root = sort_before_build_tree(array)
  end
  def sort_before_build_tree(array)
    array.sort!.uniq!
    puts "#{array}"
    root = build_tree(array)
    return root
  end
  def build_tree(array) #[1, 3, 4, 8, 9, 23, 55]
    start = 0
    last = array.size-1
    mid = array.size/2
    print "start #{array[start...mid]}  mid #{array[mid]}  last #{array[mid+1..last]} \n"
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
  def balance_tree (node)#Use for when deleting node with two children. 

  end
  def delete(value)
    #find parent
    parent = nil
    delete_node = nil
    left_child_node = nil
    right_child_node = nil
    level_order do |n|
      if n.left.data == value
        parent = n 
        delete_node = n.left
        left_child_node = n.left.left
        right_child_node = n.left.right 
        if left_child_node.nil? && right_child_node.nil?
           parent.left = nil
        elsif left_child_node.nil?
           parent.left = right_child_node
        end
        elsif right_child_node.nil?
           parent.left = left_child_node
        else
          parent.left = left_child_node
          left
        end

        break
      elsif n.right.data == value
        parent = n 
        delete_node = n.right
        left_child_node = n.right.left
        right_child_node = n.right.right 
        break
      end
    end
        #check if leaf.
  def insert(value)
    new_node = Node.new(value)
    root = @root
    while true
      if value < root.data
        if root.left.nil?
          root.left = new_node
          break
        else
          root = root.left
        end
      else  
        if root.right.nil?
          root.right = new_node
          break
        else
          root = root.right
        end
      end
    end
  end
  def level_order(array = [@root], level = 0, &block)
    return nil if array.empty?
    next_array = []
    string = ""
    array.each do |root|
      if block_given?
        yield(root, level) 
      else
        string += "#{root.data.to_s.ljust(5)} "
      end 
      next_array << root.left if root.left
      next_array << root.right if root.right
    end
    if !block_given?
      puts string.center(111, " ")
      puts
    end
    level += 1
    level_order(next_array, level, &block)
  end
  def to_s(root)
  end
end
array = [1, 4]
tree = Tree.new(array)
old_level = nil
tree.level_order
tree.insert(5)
tree.level_order
puts tree.find(5)
