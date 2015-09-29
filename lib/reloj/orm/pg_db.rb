require 'pg'
require 'uri'
require 'yaml'

class Database
  @@config = YAML.load_file(File.join(Dir.pwd, 'config/db.yml'))

  def self.create
    # TODO: handle this if db already exists
    db = PG::Connection.new(dbname: "postgres")
    db.exec("CREATE DATABASE #{@@config[:dbname]}")
  end

  def self.delete
    db = PG::Connection.new(dbname: "postgres")
    db.exec("DROP DATABASE IF EXISTS #{@@config[:dbname]}")
  end

  def self.setup
    setup_script = File.read(File.join(Dir.pwd, 'db/setup.sql'))
    db = PG::Connection.new(dbname: @@config[:dbname])
    db.exec(setup_script)
  end

  def self.reset
    self.delete
    self.create
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

  end

  def execute(*args)
    @db.exec(*args)
  end

end
