require 'rails_helper'

RSpec.describe 'Label management function', type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    visit new_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

  describe 'Registration function' do
    context 'When a label is registered' do
      it 'Registered labels are displayed.' do
        visit new_label_path

        execute_script <<~JS
          document.getElementById('labels').value = 'New Test Label';
          document.getElementById('register').closest('form').submit();
        JS

        expect(page).to have_content 'New Test Label'
      end
    end
  end

  describe 'List display function' do
    context 'When transitioning to the list screen' do
      it 'A list of registered labels is displayed.' do
        FactoryBot.create(:label, name: 'Sample Label', user: user)

        visit labels_path
        expect(page).to have_content 'Sample Label'
      end
    end
  end
end
