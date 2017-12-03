class AccountsDatatable < Effective::Datatable

  datatable do
    order :updated_at

    col :updated_at, visible: false
    col :created_at, visible: false
    col :id, visible: false

    col :name
    col :category

    actions_col destroy: false
  end

  collection do
    Account.where(user_id: attributes[:user_id]).all
  end

end
