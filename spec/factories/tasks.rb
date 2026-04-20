FactoryBot.define do
  factory :task do
    title { 'test_title' }
    content { 'test_content' }
    deadline_on { '2026-12-31' }
    priority { 'medium' }
    status { 'not_started' }
    association :user
  end
end
