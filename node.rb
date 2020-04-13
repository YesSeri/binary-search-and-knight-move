class Node
  attr_accessor :data, :left, :right
  include Comparable

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
     return -1 if other.nil?
     @data <=> other.data
  end
end
