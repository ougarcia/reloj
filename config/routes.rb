module Phase7
  @router = Phase7::Router.new

  def self.router
    return @router
  end

  @router.draw do
    get '/cats', CatsController, :index
    #get '/cats/:cat_id/statuses', StatusesController, :index
  end
end
