require_relative 'model_base'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      foreign_key: "#{name.to_s.underscore}_id".to_sym,
      primary_key: :id,
      class_name: name.to_s.camelcase.singularize
    }.merge(options)
    defaults.each do |attribute, value|
      self.send("#{attribute}=", value)
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      foreign_key: "#{self_class_name.to_s.underscore}_id".to_sym,
      primary_key: :id,
      class_name: name.to_s.singularize.camelcase
    }.merge(options)
    defaults.each do |attribute, value|
      self.send("#{attribute}=", value)
    end
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    assoc_options[name] = options = BelongsToOptions.new(name, options)
    define_method(name) do
      foreign_key_value = send(options.foreign_key)
      model_class = options.model_class
      model_class.where(options.primary_key => foreign_key_value).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.name, options)
    define_method(name) do
      options.model_class.where( options.foreign_key => id )
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class ModelBase
  extend Associatable
end
