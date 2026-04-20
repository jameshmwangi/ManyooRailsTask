require 'rails_helper'

RSpec.describe 'ユーザーモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'ユーザーの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: '', email: 'test@example.com', password: 'password')
        expect(user).not_to be_valid
      end
    end

    context 'ユーザーのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: 'テストユーザー', email: '', password: 'password')
        expect(user).not_to be_valid
      end
    end

    context 'ユーザーのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: 'テストユーザー', email: 'test@example.com', password: '')
        expect(user).not_to be_valid
      end
    end

    context 'ユーザーのメールアドレスがすでに使用されている場合' do
      it 'バリデーションに失敗する' do
        User.create(name: 'テストユーザー1', email: 'test@example.com', password: 'password')
        user = User.new(name: 'テストユーザー2', email: 'test@example.com', password: 'password')
        expect(user).not_to be_valid
      end
    end

    context 'ユーザーのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: 'テストユーザー', email: 'test@example.com', password: 'pass')
        expect(user).not_to be_valid
      end
    end

    context 'ユーザーの名前があり、メールアドレスが使用されておらず、パスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user = User.new(name: 'テストユーザー', email: 'unique@example.com', password: 'password')
        expect(user).to be_valid
      end
    end
  end
end
