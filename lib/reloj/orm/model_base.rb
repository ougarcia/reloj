require_relative 'pg_db'
require 'active_support/inflector'
require 'byebug'

class ModelBase

#  rough idea on how to replace self.finalize!
#  need to run at end of class definiton, not beginning
  #  could work if isntead of calling tablename i call self.to_s.tableize
#  def self.inherited(subclass)
#    attr_writer(*subclass.columns)
#  end

  def self.columns
    @columns ||= Database.execute(<<-SQL).fields.map(&:to_sym)
      SELECT
        *
      FROM
        #{self.table_name}
      LIMIT
        0;
    SQL
  end

  def self.finalize!
    self.columns.each do |column|
      define_method("#{column}=") do |val|
        attributes[column] = val
      end
      define_method(column) do
        attributes[column]
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.to_s.tableize
  end

  def self.all
    results_array = Database.execute(<<-SQL)
    SELECT
      *
    FROM
      #{table_name};
    SQL

    self.parse_all(results_array)
  end

  def self.parse_all(results)
    # TODO: rewrite with map
    answer = []
    results.each do |result|
      answer << self.new(result)
    end
    answer
  end

  def self.find(id)
    res = Database.execute(<<-SQL, [id])
    SELECT
      *
    FROM
      #{table_name}
    WHERE
      id = $1;
    SQL

    res.num_tuples.zero? ? nil : self.new(res.first)
  end

  def initialize(params = {})
    params.each do |column, value|
     unless self.class.columns.include?(column.to_sym)
      raise "unknown attribute '#{column}'"
     end
     self.send("#{column}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map do |column|
      self.send(column)
    end
  end

  def not_id_attribute_values
    self.class.columns.drop(1).map { |column| self.send(column) }
  end

  def insert
    my_columns = self.class.columns.drop(1)
    col_names = my_columns.join(", ")
    n = my_columns.length
    placeholders = [*1..n].map { |num| "$" + num.to_s }.join(', ')

    response = Database.execute(<<-SQL, self.not_id_attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{placeholders})
      RETURNING
        id;
    SQL
    self.id = response[0]['id'].to_i
  end

  def destroy
    Database.execute(<<-SQL)
    DELETE FROM
      #{self.class.table_name}
    WHERE
      id = #{self.id};
    SQL
  end

  def update
    columns_line = self.class.columns.map.with_index do |col_name, i|
      "#{col_name} = $#{i + 1}"
    end.join(", ")

    Database.execute(<<-SQL, self.attribute_values)
      UPDATE
        #{self.class.table_name}
      SET
        #{columns_line}
      WHERE
        id = #{self.id};
    SQL
  end

  def save
    id.nil? ? insert : update
  end
end
