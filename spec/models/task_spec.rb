require 'rails_helper'

RSpec.describe 'Task model function', type: :model do
  let!(:user) { FactoryBot.create(:user) }

  describe 'Validation test' do
    context 'If the task Title is an empty string' do
      it 'Validation fails' do
        task = Task.create(title: '', content: 'My test content.', deadline_on: '2026-12-31', priority: 'medium', status: 'not_started', user: user)
        expect(task).not_to be_valid
        expect(task.errors[:title]).to include("を入力してください")
      end
    end

    context 'If the task description is empty' do
      it 'Validation fails' do
        task = Task.create(title: 'Document preparation', content: '', deadline_on: '2026-12-31', priority: 'medium', status: 'not_started', user: user)
        expect(task).not_to be_valid
        expect(task.errors[:content]).to include("を入力してください")
      end
    end

    context 'If the task Title and description have values' do
      it 'You can register a task' do
        task = Task.create(title: 'Document preparation', content: 'My test content.', deadline_on: '2026-12-31', priority: 'medium', status: 'not_started', user: user)
        expect(task).to be_valid
      end
    end
  end

  describe 'Search function' do
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task', deadline_on: '2026-12-31', priority: 'medium', status: 'not_started', user: user) }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task', deadline_on: '2026-12-30', priority: 'high', status: 'in_progress', user: user) }
    let!(:third_task) { FactoryBot.create(:task, title: 'third_task', deadline_on: '2026-12-29', priority: 'low', status: 'completed', user: user) }

    context 'Title is performed by scope method' do
      it "Tasks containing search words are narrowed down." do
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('first')).not_to include(second_task)
        expect(Task.search_title('first')).not_to include(third_task)
        expect(Task.search_title('first').count).to eq 1
      end
    end

    context 'When the status is searched with the scope method' do
      it "Tasks that exactly match the status are narrowed down" do
        expect(Task.search_status('not_started')).to include(first_task)
        expect(Task.search_status('not_started')).not_to include(second_task)
        expect(Task.search_status('not_started')).not_to include(third_task)
        expect(Task.search_status('not_started').count).to eq 1
      end
    end

    context 'When performing fuzzy search and status search Title' do
      it "Refine your search to tasks that contain the search word Title and match the status exactly." do
        expect(Task.search_title('first').search_status('not_started')).to include(first_task)
        expect(Task.search_title('first').search_status('not_started')).not_to include(second_task)
        expect(Task.search_title('first').search_status('not_started')).not_to include(third_task)
        expect(Task.search_title('first').search_status('not_started').count).to eq 1
      end
    end
  end
end
