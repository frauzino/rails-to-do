require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/todos'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new', type: :request do
    it 'returns http success' do
      get '/todos/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /edit', type: :request do
    it 'returns http success' do
      Todo.create(title: 'Test', content: 'Test')
      get '/todos/1/edit'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create', type: :request do
    context 'with valid parameters' do
      before do
        post '/todos', params: { todo: { title: 'Test', content: 'Test' } }, as: :turbo_stream
      end

      it 'creates a new Todo' do
        expect(Todo.count).to eq(1)
      end

      it 'appends the new Todo to the list' do
        expect(response.body).to include('turbo-stream action="append" target="todos"')
      end

      it 'replaces the submitted form with the new form partial' do
        expect(response.body).to include('turbo-stream action="replace" target="todo_form"')
        expect(response.body).to include('form id="todo_form"')
      end

      it 'prepends a success flash message' do
        expect(response.body).to include('turbo-stream action="prepend" target="flashes"')
        expect(response.body).to include('div class="flash flash-success"')
        expect(response.body).to include('Post created successfully.')
      end
    end

    context 'with invalid parameters' do
      before do
        post '/todos', params: { todo: { title: 'Test Title', content: '' } }, as: :turbo_stream
      end

      it 'does not create a new Todo' do
        expect(Todo.count).to eq(0)
      end

      it 'replaces the error form with the new form partial' do
        expect(response.body).to include('turbo-stream action="replace" target="todo_form"')
        expect(response.body).to include('form id="todo_form"')
      end

      it 'retains the submitted form values' do
        expect(response.body).to include('value="Test Title"')
      end

      it 'prepends an error flash message' do
        expect(response.body).to include('turbo-stream action="prepend" target="flashes"')
        expect(response.body).to include('div class="flash flash-error"')
        expect(response.body).to include('Content can&#39;t be blank')
      end
    end
  end

  describe 'PATCH /update', type: :request do
    context 'with valid parameters' do
      before do
        Todo.create(title: 'Test Title', content: 'Test Content')
        patch '/todos/1', params: { todo: { title: 'Updated Test Title', content: 'Updated Test Content' } }, as: :turbo_stream
      end

      it 'replaces the title with the updated title' do
        expect(Todo.last.reload.title).to eq('Updated Test Title')
      end

      it 'replaces the content with the updated content' do
        expect(Todo.last.reload.content).to eq('Updated Test Content')
      end

      it 'replaces the submitted form with the new form partial' do
        expect(response.body).to include('turbo-stream action="replace" target="todo_form"')
        expect(response.body).to include('form id="todo_form"')
      end

      it 'prepends a success flash message' do
        expect(response.body).to include('turbo-stream action="prepend" target="flashes"')
        expect(response.body).to include('div class="flash flash-success"')
        expect(response.body).to include('Post updated successfully.')
      end
    end

    context 'with invalid parameters' do
      before do
        Todo.create(title: 'Test Title', content: 'Test Content')
        patch '/todos/1', params: { todo: { title: 'Updated Test Title', content: '' } }, as: :turbo_stream
      end

      it 'does not update the Todo title' do
        expect(Todo.last.reload.title).to eq('Test Title')
      end

      it 'does not update the Todo content' do
        expect(Todo.last.reload.content).to eq('Test Content')
      end

      it 'replaces the error form with the new form partial' do
        expect(response.body).to include('turbo-stream action="replace" target="todo_form"')
        expect(response.body).to include('form id="todo_form"')
      end

      it 'retains the submitted form values' do
        expect(response.body).to include('value="Updated Test Title"')
      end

      it 'prepends an error flash message' do
        expect(response.body).to include('turbo-stream action="prepend" target="flashes"')
        expect(response.body).to include('div class="flash flash-error"')
        expect(response.body).to include('Content can&#39;t be blank')
      end
    end
  end

  describe 'DELETE /destroy', type: :request do
    before do
      Todo.create(title: 'Test', content: 'Test')
      delete '/todos/1', as: :turbo_stream
    end

    it 'deletes an existing Todo' do
      expect(Todo.count).to eq(0)
    end

    it 'removes the Todo from the list' do
      expect(response.body).to include('turbo-stream action="remove" target="todo_1"')
    end

    it 'replaces the submitted form with the new form partial' do
      expect(response.body).to include('turbo-stream action="replace" target="todo_form"')
    end

    it 'prepends a success flash message' do
      expect(response.body).to include('turbo-stream action="prepend" target="flashes"')
      expect(response.body).to include('div class="flash flash-success"')
      expect(response.body).to include('Post deleted successfully.')
    end
  end
end
