class CatsController < Reloj::ControllerBase

  def create
    @cat = Cat.new(params["cat"])
    if @cat.save
      redirect_to("/cats")
    else
      render :new
    end
  end

  def index
    session['count'] ||= 0
    session['count'] += 1
    @cats = Cat.all
    render :index
  end

  def new
    @cat = Cat.new
    render :new
  end
end
