class Stack

  attr_accessor :store
  
  def initialize
    @store = []
  end
  def push(element)
    @store.push(element)
    self
  end
  def pop
    @store.pop
  end
  def size
    @store.size
  end
  def empty?
    @store.size.zero?
  end
end