# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

puts '== Creating users ======================'

user = User.new(
  first_name: 'Admin',
  last_name: 'Yarr',
  email: 'admin@codeandeffect.com',
  password: 'be_effective',
  password_confirmation: 'be_effective',
  roles: :admin
)
user.save!


user.categories.build(debit: true, name: 'General Income', heading: 'Income').save!
user.categories.build(credit: true, name: 'General Expenses', heading: 'Expenses').save!
user.accounts.build(name: 'Joint Chequing', category: 'Asset').save!
user.accounts.build(name: 'Matt Visa', category: 'Asset').save!
user.accounts.build(name: 'Roxy Visa', category: 'Asset').save!
