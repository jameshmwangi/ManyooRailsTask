require 'rails_helper'

RSpec.describe 'ユーザー管理機能', type: :system do
  describe '登録機能' do
    context 'ユーザーを登録した場合' do
      it 'タスク一覧画面に遷移する' do
        visit new_user_path
        fill_in '名前', with: 'テストユーザー'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        click_button '登録する'

        expect(page).to have_content 'タスク一覧'
        expect(page).to have_content 'アカウントを登録しました'
      end
    end

    context 'ログインせずにタスク一覧画面に遷移しようとした場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq new_session_path
      end
    end
  end

  describe 'ログイン機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:user, email: 'other@example.com') }

    context '登録済みのユーザーとしてログインした場合' do
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
      end

      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(page).to have_content 'ログインしました'
        expect(current_path).to eq tasks_path
      end

      it '自分の詳細画面にアクセスできる' do
        visit user_path(user)
        expect(page).to have_content user.name
      end

      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        visit user_path(other_user)
        expect(page).to have_content 'アクセス権限がありません'
        expect(current_path).to eq tasks_path
      end

      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_link 'ログアウト'
        expect(page).to have_content 'ログアウトしました'
        expect(current_path).to eq new_session_path
      end
    end
  end

  describe '管理者機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:admin_user) { FactoryBot.create(:admin_user) }

    context '管理者がログインした場合' do
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: admin_user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
      end

      it 'ユーザー一覧画面にアクセスできる' do
        visit admin_users_path
        expect(page).to have_content 'ユーザ一覧'
      end

      it '管理者を登録できる' do
        visit new_admin_user_path
        fill_in '名前', with: '新管理者'
        fill_in 'メールアドレス', with: 'newadmin@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        check '管理者権限'
        click_button '登録する'

        expect(page).to have_content 'ユーザを登録しました'
      end

      it 'ユーザー詳細画面にアクセスできる' do
        visit admin_user_path(user)
        expect(page).to have_content user.name
      end

      it 'ユーザー編集画面から、自分以外のユーザーを編集できる' do
        visit edit_admin_user_path(user)
        fill_in '名前', with: 'アップデート名'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        click_button '更新する'

        expect(page).to have_content 'ユーザを更新しました'
      end

      it 'ユーザーを削除できる', js: true do
        visit admin_users_path

        expect(page).to have_content 'ユーザ一覧ページ'
        expect(page).to have_selector('.destroy-user')

        page.accept_confirm '本当に削除してもよろしいですか？' do
          click_link '削除', match: :first
        end

        expect(page).to have_content 'ユーザを削除しました'
      end
    end

    context '一般ユーザーがユーザー一覧画面にアクセスした場合' do
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
      end

      it 'タスク一覧画面に遷移し、「管理者以外はアクセスできません」というエラーメッセージが表示される' do
        visit admin_users_path
        expect(page).to have_content '管理者以外アクセスできません'
        expect(current_path).to eq tasks_path
      end
    end
  end
end
