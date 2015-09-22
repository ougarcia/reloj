require_relative '../../lib/orm/model_base'
class Cat < ModelBase

  def inspect
    { name: @name }.inspect
  end
end
