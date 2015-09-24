#require_relative '../../lib/orm/model_base'
class Cat < ModelBase

  def inspect
    { name: self.name }.inspect
  end

  finalize!
end
