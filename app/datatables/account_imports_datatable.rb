class AccountImportsDatatable < Effective::Datatable

  datatable do
    order :updated_at

    col :updated_at, visible: false
    col :id, visible: false

    col :account
    col :created_at
    col :items

    actions_col
  end

  collection do
    Import.deep.where(account: account).all
  end

  def account
    @account ||= Account.find(attributes[:account_id])
  end

end
