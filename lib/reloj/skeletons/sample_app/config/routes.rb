module App
  ROUTES = Proc.new do

    get '/', TodosController, :index
    get '/todos', TodosController, :index
    get '/todos/new', TodosController, :new
    post '/todos/:id/delete', TodosController, :destroy
    post '/todos', TodosController, :create

  end
end
