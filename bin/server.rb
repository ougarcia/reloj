require 'webrick'
require_relative '../lib/controller_base'
require_relative '../lib/router'
# gotta require models, then views, then controllers, then routes
require_relative '../app/models/cat'
require_relative '../app/controllers/cats_controller'
require_relative '../config/routes.rb'

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = Phase7.router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
