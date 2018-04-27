class ISTNode
  attr_accessor :s, :e, :left, :right, :largest, :is_right, :parent

  def initialize(s, e)
    @s = s
    @e = e
    @largest = e
    @left = nil
    @right = nil

    @is_right = nil
    @parent = nil
  end

end
