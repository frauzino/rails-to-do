class TodosController < ApplicationController
  before_action :set_todo, only: %i[show edit update destroy]

  # GET /todos or /todos.json
  def index
    @todos = Todo.all.sort_by(&:updated_at).reverse
    @todo_titles = Todo.pluck(:title)
    @todo = Todo.new
  end

  # GET /todos/new
  def new
    @todo = Todo.new
    respond_to do |format|
      format.html { render :new }
    end
  end

  # GET /todos/1/edit
  def edit
    @todo = Todo.find(params[:id])
    respond_to do |format|
      format.html { render :edit }
    end
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append('todos', @todo),
            turbo_stream.replace('todo_form', partial: 'form', locals: { todo: Todo.new, action: 'New Note' }),
            turbo_stream.prepend('flashes', partial: 'shared/flashes', locals: { notice: 'Post created successfully.', alert: 'success'})
          ]
        end
      else
        errors = @todo.errors.full_messages.join(', ')
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('todo_form', partial: 'form', locals: { todo: @todo, action: 'New Note' }),
            turbo_stream.prepend('flashes', partial: 'shared/flashes', locals: { notice: errors, alert: 'error'})
          ]
        end
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("title_#{@todo.id}", @todo.title),
            turbo_stream.replace('todo_form', partial: 'form', locals: { todo: Todo.new, action: 'New Note' }),
            turbo_stream.prepend('flashes', partial: 'shared/flashes', locals: { notice: 'Post updated successfully.', alert: 'success'})
          ]
        end
      else
        errors = @todo.errors.full_messages.join(', ')
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('todo_form', partial: 'form', locals: { todo: @todo, action: 'New Note' }),
            turbo_stream.prepend('flashes', partial: 'shared/flashes', locals: { notice: errors, alert: 'error'})
          ]
        end
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@todo),
          turbo_stream.replace('todo_form', partial: 'form', locals: { todo: Todo.new, action: 'New Note' }),
          turbo_stream.prepend('flashes', partial: 'shared/flashes', locals: { notice: 'Post deleted successfully.', alert: 'success'})
        ]
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_todo
    @todo = Todo.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def todo_params
    params.require(:todo).permit(:content, :title)
  end
end
