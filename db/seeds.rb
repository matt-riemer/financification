# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

puts '== Creating users ======================'

User.new(
  first_name: 'Admin',
  last_name: 'Yarr',
  email: 'admin@codeandeffect.com',
  password: 'be_effective',
  password_confirmation: 'be_effective',
  roles: :admin
).save!
