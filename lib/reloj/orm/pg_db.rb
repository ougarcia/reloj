require 'pg'
require 'uri'
require 'yaml'

class Database

  def self.create
    db = PG::Connection.new(dbname: "postgres")
    db.exec("CREATE DATABASE #{config[:dbname]}")
  end

  def self.delete
    db = PG::Connection.new(dbname: "postgres")
    db.exec("DROP DATABASE IF EXISTS #{config[:dbname]}")
  end

  def self.setup
    setup_script = File.read(File.join(Dir.pwd, 'db/setup.sql'))
    execute(setup_script)
  end

  def self.reset
    self.delete
    self.create
  end

  def self.config
    @config ||= YAML.load_file(File.join(Dir.pwd, 'config/db.yml'))
  end

  def self.parse_params(params)
    {
      host: params.host,
      dbname: params.path[1..-1],
      port: params.port,
      password: params.password,
      user: params.user
    }
  end

  def self.set_db
    params = ENV["DATABASE_URL"] && URI.parse(ENV["DATABASE_URL"])
    db_options = params.nil? ? config : parse_params(params)

    @db ||= PG::Connection.new(db_options)
  end

  def self.instance
    set_db if @db.nil?

    @db
  end

  def self.execute(*args)
    pretty_print_sql(*args)
    instance.exec(*args)
  end

  def self.pretty_print_sql(*sql_args)
    pretty = sql_args.map do |a|
      a.is_a?(String) ? a.gsub(/\s+/, " ").gsub(/;\s/, ";\n") : a.join(", ")
    end.join("\n")
    print "\n#{pretty}\n"
  end

end
