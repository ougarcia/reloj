require 'byebug'

class TodosController < Reloj::ControllerBase

  def index
    @todos = Todo.all
    render :index
  end

  def new
    @todo = Todo.new
    render :new
  end

  def create
    @todo = Todo.new(params[:todo])
    if @todo.title == "" || @todo.save
      redirect_to "/"
    else
      render :new
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    render_content("{}", "application/json")
  end
end
