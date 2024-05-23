require 'rails_helper'

RSpec.describe Todo, type: :model do
  it 'is valid with content' do
    todo = Todo.new(content: 'Test string')
    expect(todo).to be_valid
  end

  context 'when title is blank and content is present' do
    it 'sets title from content' do
      todo = Todo.create(content: 'Very Long Test string')
      expect(todo.title).to eq('Very Long Test')
    end
  end
end
