class ISTNode
  attr_accessor :s, :e, :left, :right, :largest, :parent

  def initialize(s, e)
    @s = s
    @e = e
    @largest = e
    @left = nil
    @right = nil

    # @is_right = nil
    @parent = nil
  end

  def is_right
    return nil if @parent.nil?
    return true if @s > @parent.s
    return false if @s <= @parent.s

  end

end
