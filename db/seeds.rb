Task.delete_all
User.delete_all

# Create a general user
general_user = User.create!(
  name: 'General User',
  email: 'user@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: false
)

# Create an administrator
admin_user = User.create!(
  name: 'Admin User',
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true
)

# Generate 50 tasks for the General User
50.times do |n|
  general_user.tasks.create!(
    title: "General Task #{n + 1}",
    content: "This is general task number #{n + 1}",
    deadline_on: Date.today + (n % 10).days,
    priority: n % 3,
    status: n % 3
  )
end

# Generate 50 tasks for the Admin User
50.times do |n|
  admin_user.tasks.create!(
    title: "Admin Task #{n + 1}",
    content: "This is admin task number #{n + 1}",
    deadline_on: Date.today + (n % 10).days,
    priority: n % 3,
    status: n % 3
  )
end