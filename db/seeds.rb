50.times do |i|
  Task.create!(
    title: "Task #{i + 1}",
    content: "This is the content for task #{i + 1}." )
end