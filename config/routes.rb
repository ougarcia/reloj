module App
  ROUTES = Proc.new do
#   put the routes for your app here, e.g.
#   get '/cats/:cat_id/statuses', StatusesController, :index
    get '/cats', CatsController, :index
  end
end
