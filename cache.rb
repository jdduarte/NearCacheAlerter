class Cache
  attr_accessor :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def eql?(object)
    self.class.equal?(object.class) &&
        object.id == id
  end

  def hash()
    @id.hash
  end
end