require_relative 'associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    self_options = assoc_options[name]
    through_options = assoc_options[through_name]
    #very close to finishing
    define_method(name) do
      # p all your assoc_options keys/values
      source_options = through_options.model_class.assoc_options[source_name]
      source_table = source_options.table_name
      through_table = through_options.table_name
      x = DBConnection.execute(<<-SQL)
        SELECT
          #{source_table}.*
        FROM
          #{source_table}
        INNER JOIN
          #{through_table}
        ON
          #{source_table}.id = #{through_table}.#{source_options.foreign_key}
        INNER JOIN
          #{self.class.table_name}
        ON
          #{self.class.table_name}.#{through_options.foreign_key} = #{through_table}.id;
      SQL

      source_options.model_class.parse_all(x).first
      # use constantize
    end
  end
end
