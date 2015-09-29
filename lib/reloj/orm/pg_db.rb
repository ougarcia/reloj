require 'pg'
require 'uri'
require 'yaml'

class Database
  @@config = YAML.load_file(File.join(Dir.pwd, 'config/db.yml'))

  def self.create
    #write the actual SQL to create a table
    db = PG::Connection.new(dbname: "postgres")
    db.exec("CREATE DATABASE #{@@config[:dbname]}")
  end

  def self.seed
  end

  def self.reset
  end

  def initialize
    params = URI.parse(ENV["DATABASE_URL"])
    if params.nil?
      db_options = @@config
    else
      db_options = {
        host: params.host,
        dbname: params.path[1..-1],
        port: params.port,
        password: params.password,
        user: x.user
      }
    end

    @db = PG::Connection.new(db_options)

    @db
  end

end
