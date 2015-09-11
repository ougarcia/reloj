router = Phase7::Router.new
router.draw do
  get '/cats', CatsController, :index
  get '/cats/:cat_id/statuses', StatusesController, :index
end
