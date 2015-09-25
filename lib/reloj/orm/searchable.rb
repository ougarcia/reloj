require_relative 'db_connection'
require_relative 'model_base'

module Searchable

  def where(params)
    conditions = params.map do |key, value|
      "#{key} = ?"
    end.join(" AND ")
    result = DBConnection.execute(<<-SQL, params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{conditions};
    SQL

    self.parse_all(result)
  end

end

class ModelBase
  extend Searchable
end
