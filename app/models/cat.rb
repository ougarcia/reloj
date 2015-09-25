class Cat < ModelBase

  def inspect
    { name: self.name }.inspect
  end

  finalize!
end
