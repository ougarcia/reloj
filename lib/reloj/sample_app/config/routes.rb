module App
  ROUTES = Proc.new do
#   put the routes for your app here, e.g.
#   get '/cats/:cat_id/statuses', StatusesController, :index

    get '/cats', CatsController, :index
    get '/cats/new', CatsController, :new
    post '/cats', CatsController, :create
  end
end
