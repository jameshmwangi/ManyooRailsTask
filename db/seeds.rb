# Seed at least 10 tasks with different values for title, content, deadline, priority and status
50.times do |i|
  Task.create!(
    title: "Task #{i + 1}",
    content: "This is the content for task #{i + 1}.",
    deadline_on: Date.today + i.days,
    priority: i % 3,
    status: i % 3
  )
end