require 'rails_helper'

RSpec.describe 'Task management function', type: :system do
  describe 'Registration' do
    context 'when a user submits a new task' do
      it 'displays the newly created task' do
        visit new_task_path
        fill_in 'タイトル', with: 'My Test Task'
        fill_in '内容', with: 'My test content.'
        click_button '登録する'

        expect(page).to have_content 'タスクを登録しました'
        expect(page).to have_content 'My Test Task'
      end
    end
  end

  describe 'Task list' do
    let!(:first_task)  { FactoryBot.create(:task, title: 'first_task',  created_at: '2026-02-18') }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task', created_at: '2026-02-12') }
    let!(:third_task)  { FactoryBot.create(:task, title: 'third_task',  created_at: '2026-01-06') }

    before { visit tasks_path }   

    context 'when the list page is loaded' do
      it 'shows all registered tasks' do
        expect(page).to have_content 'first_task'
        expect(page).to have_content 'second_task'
        expect(page).to have_content 'third_task'
      end

      it 'orders tasks by creation date, newest first' do
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'first_task'
        expect(task_list[1]).to have_content 'second_task'
        expect(task_list[2]).to have_content 'third_task'
      end
    end

    context 'when a new task is created' do
      it 'appears at the top of the list' do
        visit new_task_path
        fill_in 'タイトル', with: 'newly_created_task'
        fill_in '内容', with: 'My test content.'
        click_button '登録する'

        expect(page).to have_content 'タスクを登録しました'
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'newly_created_task'
      end
    end
  end

  describe 'Task detail' do
    context 'when a user visits a task page' do
      it 'displays the full task content' do
        task = FactoryBot.create(:task, title: 'Document preparation', content: 'My test content.')
        visit task_path(task.id)

        expect(page).to have_content 'Document preparation'
        expect(page).to have_content 'My test content.'
      end
    end
  end
end