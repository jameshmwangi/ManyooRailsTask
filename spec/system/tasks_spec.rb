require 'rails_helper'

RSpec.describe 'Task management function', type: :system do
  describe 'Registration' do
    context 'when a user submits a new task' do
      it 'displays the newly created task' do
        visit new_task_path
        fill_in 'タイトル', with: 'My Test Task'
        fill_in '内容', with: 'My test content.'
        fill_in '終了期限', with: '2026-04-28'
        select '中', from: '優先度'
        select '未着手', from: 'ステータス'
        click_button '登録する'

        expect(page).to have_content 'タスクを登録しました'
        expect(page).to have_content 'My Test Task'
      end
    end
  end

  describe 'Task list' do
    # Three test data sets with different title, deadline, priority and status
    let!(:first_task)  { FactoryBot.create(:task, title: 'first_task',  created_at: '2025-02-18', deadline_on: '2022-02-18', priority: 'medium', status: 'not_started') }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task', created_at: '2025-02-17', deadline_on: '2022-02-17', priority: 'high', status: 'in_progress') }
    let!(:third_task)  { FactoryBot.create(:task, title: 'third_task',  created_at: '2025-02-16', deadline_on: '2022-02-16', priority: 'low', status: 'completed') }

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
        fill_in '終了期限', with: '2026-12-31'
        select '中', from: '優先度'
        select '未着手', from: 'ステータス'
        click_button '登録する'

        expect(page).to have_content 'タスクを登録しました'
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'newly_created_task'
      end
    end

    describe 'sort function' do
      context 'If you click on the link "Exit Deadline"' do
        it "A list of tasks sorted in ascending order of due date is displayed." do
          click_link '終了期限'
          sleep 0.5

          task_list = all('tbody tr')
          # 2022-02-16 is earliest, so third_task should be at the top
          expect(task_list[0]).to have_content 'third_task'
          expect(task_list[1]).to have_content 'second_task'
          expect(task_list[2]).to have_content 'first_task'
        end
      end

      context 'If you click on the link "Priority"' do
        it "A list of tasks sorted by priority is displayed" do
          click_link '優先度'
          sleep 0.5

          task_list = all('tbody tr')
          # High (second_task) -> Medium (first_task) -> Low (third_task)
          expect(task_list[0]).to have_content 'second_task'
          expect(task_list[1]).to have_content 'first_task'
          expect(task_list[2]).to have_content 'third_task'
        end
      end
    end

    describe 'Search function' do
      context 'If you do a fuzzy search by Title' do
        it "Only tasks containing the search word will be displayed." do
          fill_in 'タイトル', with: 'first'
          click_button '検索'

          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'
        end
      end

      context 'Search by status' do
        it "Only tasks matching the searched status will be displayed" do
          # Test "Not started"
          select '未着手', from: 'ステータス'
          click_button '検索'
          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'

          # Test "In progress"
          select '着手中', from: 'ステータス'
          click_button '検索'
          expect(page).not_to have_content 'first_task'
          expect(page).to have_content 'second_task'
          expect(page).not_to have_content 'third_task'

          # Test "Completed"
          select '完了', from: 'ステータス'
          click_button '検索'
          expect(page).not_to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).to have_content 'third_task'
        end
      end

      context 'Title and search by status' do
        it "Only tasks that contain the search word Title and match the status will be displayed" do
          fill_in 'タイトル', with: 'first'
          select '未着手', from: 'ステータス'
          click_button '検索'

          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'
        end
      end
    end
  end

  describe 'Task detail' do
    context 'when a user visits a task page' do
      it 'displays the full task content' do
        task = FactoryBot.create(:task, title: 'Document preparation', content: 'My test content.', deadline_on: '2026-12-31', priority: 'medium', status: 'not_started')
        visit task_path(task.id)

        expect(page).to have_content 'Document preparation'
        expect(page).to have_content 'My test content.'
      end
    end
  end
end