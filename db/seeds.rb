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

# Incomes
salary = user.category_groups.create!(credit: true, name: 'Salary')
income = user.category_groups.create!(credit: true, name: 'Other Income')

user.categories.create!(credit: true, category_group: salary, name: 'Roxanne')
user.categories.create!(credit: true, category_group: salary, name: 'Matthew (AgileStyle Inc)')
user.categories.create!(credit: true, category_group: salary, name: 'Matthew (BugByte Software)')
user.categories.create!(credit: true, category_group: salary, name: 'Matthew (Code & Effect)')
user.categories.create!(credit: true, category_group: salary, name: 'Matthew (Code & Effect)')

user.categories.create!(credit: true, category_group: income, name: 'Roxanne EI (Maternity Leave)')
user.categories.create!(credit: true, category_group: income, name: 'Childcare Benefit (Canada FED and CTC)')
user.categories.create!(credit: true, category_group: income, name: 'Rental Income for BSMT 5208-109st')
user.categories.create!(credit: true, category_group: income, name: 'Others (transfers in)')

# Expenses
bills = user.category_groups.create!(debit: true, name: 'Bills')
household = user.category_groups.create!(debit: true, name: 'Household')
entertainment = user.category_groups.create!(debit: true, name: 'Entertainment & Hobbies')

user.category_groups.create!(debit: true, name: 'Health and Wellness')
user.category_groups.create!(debit: true, name: 'Home Renovations')
user.category_groups.create!(debit: true, name: 'Insurance')
user.category_groups.create!(debit: true, name: 'Banking, Professional & Governmental Fees')
user.category_groups.create!(debit: true, name: 'Vacations')
user.category_groups.create!(debit: true, name: 'Car Expenses')
user.category_groups.create!(debit: true, name: 'Transfer to Visa / Other Accounts')

user.categories.create!(debit: true, category_group: bills, name: 'MCAP Mortgage')
user.categories.create!(debit: true, category_group: bills, name: 'Property Taxes')
user.categories.create!(debit: true, category_group: bills, name: 'EPCOR (Water)')
user.categories.create!(debit: true, category_group: bills, name: 'Direct Energy (Electricity & Gas)')
user.categories.create!(debit: true, category_group: bills, name: 'Internet')
user.categories.create!(debit: true, category_group: bills, name: 'Cellphone')
user.categories.create!(debit: true, category_group: bills, name: 'Netflix')

user.categories.create!(debit: true, category_group: household, name: 'Groceries')
user.categories.create!(debit: true, category_group: entertainment, name: 'Pizza')



user.accounts.build(name: 'Joint Chequing', category: 'Asset').save!
user.accounts.build(name: 'Matt Visa', category: 'Asset').save!
user.accounts.build(name: 'Roxy Visa', category: 'Asset').save!
