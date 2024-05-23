json.extract! todo, :id, :content, :created_at, :updated_at
json.url todo_url(todo, format: :json)
