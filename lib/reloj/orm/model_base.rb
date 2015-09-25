require_relative 'db_connection'
require 'active_support/inflector'

class ModelBase

#  rough idea on how to replace self.finalize!
#  need to run at end of class definiton, not beginning
#  def self.inherited(subclass)
#    attr_writer(*subclass.columns)
#  end

  def self.columns
    result = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      LIMIT
        0;
    SQL

    result.first.map(&:to_sym)
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
    results_array = DBConnection.execute(<<-SQL)
    SELECT
      *
    FROM
      #{table_name};
    SQL

    self.parse_all(results_array)
  end

  def self.parse_all(results)
    answer = []
    results.each do |result|
      answer << self.new(result)
    end
    answer
  end

  def self.find(id)
    x = DBConnection.execute(<<-SQL, id)
    SELECT
      *
    FROM
      #{table_name}
    WHERE
      id = ?;
    SQL

    x.empty? ? nil : self.new(x.first)
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

  def insert
    my_columns = self.class.columns
    col_names = my_columns.join(", ")
    n = my_columns.length
    question_marks = (["?"] * n).join(", ")

    DBConnection.execute(<<-SQL, self.attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks});
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    columns_line = self.class.columns.map do |col_name|
      "#{col_name} = ?"
    end.join(", ")

    DBConnection.execute(<<-SQL, self.attribute_values, self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{columns_line}
      WHERE
        id = ?;
    SQL
  end

  def save
    id.nil? ? insert : update
  end
end
