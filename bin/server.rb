require 'webrick'
require_relative '../lib/controller_base'
require_relative '../lib/router'

require 'require_all'
require_rel '../app/**/*.rb'
require_relative '../config/routes.rb'

router = Phase7::Router.new
router.draw(&App::ROUTES)

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
