class AccountsDatatable < Effective::Datatable

  datatable do
    order :updated_at

    col :updated_at, visible: false
    col :created_at, visible: false
    col :id, visible: false

    col :user
    col :name
    col :category

    actions_col
  end

  collection do
    Account.all
  end

end
