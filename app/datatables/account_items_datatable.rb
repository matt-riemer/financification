class AccountItemsDatatable < Effective::Datatable

  datatable do
    order :updated_at

    col :updated_at, visible: false
    col :created_at, visible: false
    col :id, visible: false

    col :account
    col :category

    col :date
    col :name
    col :debit, as: :price
    col :credit, as: :price
    col :balance, as: :price
    col :note, visible: false

    col :import, visible: false
    col :rule, visible: false
    col :original, visible: false

    actions_col
  end

  collection do
    Item.deep.where(account: account).all
  end

  def account
    @account ||= Account.find(attributes[:account_id])
  end

end
